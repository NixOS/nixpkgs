# Sourcery CodeBench Lite toolchain(s) (GCC) from Mentor Graphics

{ stdenv, fetchurl, patchelf, ncurses }:

let

  buildToolchain =
    { name, src, description }:

    stdenv.mkDerivation rec {
      inherit name src;

      buildInputs = [ patchelf ];

      buildCommand = ''
        # Unpack tarball
        mkdir -p "$out"
        tar --strip-components=1 -xjf "$src" -C "$out"

        # Patch binaries
        interpreter="$(cat "$NIX_CC"/nix-support/dynamic-linker)"
        for file in "$out"/bin/* "$out"/libexec/gcc/*/*/* "$out"/*/bin/*; do
            # Skip non-executable files
            case "$file" in
              *README.txt) echo "skipping $file"; continue;;
              *liblto_plugin.so*) echo "skipping $file"; continue;;
            esac

            # Skip directories
            test -d "$file" && continue

            echo "patchelf'ing $file"
            patchelf --set-interpreter "$interpreter" "$file"

            # GDB needs ncurses
            case "$file" in
              *gdb) patchelf --set-rpath "${ncurses.out}/lib" "$file";;
            esac
        done

        # Manpages
        mkdir -p "$out/share/man"
        ln -s "$out"/share/doc/*/man/man1 "$out/share/man/man1"
        ln -s "$out"/share/doc/*/man/man7 "$out/share/man/man7"
      '';

      meta = with stdenv.lib; {
        inherit description;
        homepage = http://www.mentor.com/embedded-software/sourcery-tools/sourcery-codebench/editions/lite-edition/;
        license = licenses.gpl3;
        platforms = platforms.linux;
        maintainers = [ maintainers.bjornfor ];
      };
    };

in

{

  armLinuxGnuEabi = let version = "2013.05-24"; in buildToolchain rec {
    name = "sourcery-codebench-lite-arm-linux-gnueabi-${version}";
    description = "Sourcery CodeBench Lite toolchain (GCC) for ARM GNU/Linux, from Mentor Graphics";
    src = fetchurl {
      url = "http://sourcery.mentor.com/public/gnu_toolchain/arm-none-linux-gnueabi/arm-${version}-arm-none-linux-gnueabi-i686-pc-linux-gnu.tar.bz2";
      sha256 = "1xb075ia61c59cya2jl8zp4fvqpfnwkkc5330shvgdlg9981qprr";
    };
  };

  armEabi = let version = "2013.05-23"; in buildToolchain rec {
    name = "sourcery-codebench-lite-arm-eabi-${version}";
    description = "Sourcery CodeBench Lite toolchain (GCC) for ARM EABI, from Mentor Graphics";
    src = fetchurl {
      url = "http://sourcery.mentor.com/public/gnu_toolchain/arm-none-eabi/arm-${version}-arm-none-eabi-i686-pc-linux-gnu.tar.bz2";
      sha256 = "0nbvdwj3kcv9scx808gniqp0ncdiy2i7afmdvribgkz1lsfin923";
    };
  };

  # TODO: Sourcery CodeBench is also available for MIPS, Power, SuperH,
  # ColdFire (and more).
}
