{ stdenv, fetchFromGitHub, jdk, jre, ant, coreutils, gnugrep, file }:

stdenv.mkDerivation rec {

  version = "1.0.6";
  name = "arduino-core";

  src = fetchFromGitHub {
    owner = "arduino";
    repo = "Arduino";
    rev = "${version}";
    sha256 = "0nr5b719qi03rcmx6swbhccv6kihxz3b8b6y46bc2j348rja5332";
  };

  buildInputs = [ jdk ant file ];

  buildPhase = ''
    cd ./core && ant 
    cd ../build && ant 
    cd ..
  '';

  installPhase = ''
    mkdir -p $out/share/arduino
    cp -r ./build/linux/work/hardware/ $out/share/arduino
    cp -r ./build/linux/work/libraries/ $out/share/arduino
    cp -r ./build/linux/work/tools/ $out/share/arduino
    cp -r ./build/linux/work/lib/ $out/share/arduino
    echo ${version} > $out/share/arduino/lib/version.txt

    # Fixup "/lib64/ld-linux-x86-64.so.2" like references in ELF executables.
    echo "running patchelf on prebuilt binaries:"
    find "$out" | while read filepath; do
        if file "$filepath" | grep -q "ELF.*executable"; then
            # skip target firmware files
            if echo "$filepath" | grep -q "\.elf$"; then
                continue
            fi
            echo "setting interpreter $(cat "$NIX_CC"/nix-support/dynamic-linker) in $filepath"
            patchelf --set-interpreter "$(cat "$NIX_CC"/nix-support/dynamic-linker)" "$filepath"
            test $? -eq 0 || { echo "patchelf failed to process $filepath"; exit 1; }
        fi
    done
  '';

  meta = {
    description = "Libraries for the open-source electronics prototyping platform";
    homepage = http://arduino.cc/;
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.antono stdenv.lib.maintainers.robberer ];
  }; 
}
