{stdenv, stdenv_32bit, fetchurl, unzip, zlib_32bit, ncurses_32bit, file, zlib, ncurses}:

stdenv.mkDerivation rec {
  version = "28.0.3";
  name = "android-build-tools-r${version}";
  src = if (stdenv.hostPlatform.system == "i686-linux" || stdenv.hostPlatform.system == "x86_64-linux")
    then fetchurl {
      url = "https://dl.google.com/android/repository/build-tools_r${version}-linux.zip";
      sha256 = "16klhw9yk8znvbgvg967km4y5sb87z1cnf6njgv8hg3381m9am3r";
    }
    else if stdenv.hostPlatform.system == "x86_64-darwin" then fetchurl {
      url = "https://dl.google.com/android/repository/build-tools_r${version}-macosx.zip";
      sha256 = "1src9g7058bl2z9y6v404gwqwpixb8b71awxhrb0w5iwnfabhymq";
    }
    else throw "System ${stdenv.hostPlatform.system} not supported!";

  buildCommand = ''
    mkdir -p $out/build-tools
    cd $out/build-tools
    unzip $src
    mv android-* ${version}

    ${stdenv.lib.optionalString (stdenv.hostPlatform.system == "i686-linux" || stdenv.hostPlatform.system == "x86_64-linux")
      ''
        cd ${version}

        ln -s ${ncurses.out}/lib/libncurses.so.5 `pwd`/lib64/libtinfo.so.5

        find . -type f -print0 | while IFS= read -r -d "" file
        do
          type=$(file "$file")
          ## Patch 64-bit binaries
          if grep -q "ELF 64-bit" <<< "$type"
          then
            if grep -q "interpreter" <<< "$type"
            then
              patchelf --set-interpreter ${stdenv.cc.libc.out}/lib/ld-linux-x86-64.so.2 "$file"
            fi
            patchelf --set-rpath `pwd`/lib64:${stdenv.cc.cc.lib.out}/lib:${zlib.out}/lib:${ncurses.out}/lib "$file"
          ## Patch 32-bit binaries
          elif grep -q "ELF 32-bit" <<< "$type"
          then
            if grep -q "interpreter" <<< "$type"
            then
              patchelf --set-interpreter ${stdenv_32bit.cc.libc.out}/lib/ld-linux.so.2 "$file"
            fi
            patchelf --set-rpath ${stdenv_32bit.cc.cc.lib.out}/lib:${zlib_32bit.out}/lib:${ncurses_32bit.out}/lib "$file"
          fi
        done
      ''}

      patchShebangs .
  '';

  buildInputs = [ unzip file ];
}
