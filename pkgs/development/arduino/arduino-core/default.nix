{ stdenv, fetchFromGitHub, jdk, jre, ant, coreutils, gnugrep }:

stdenv.mkDerivation rec {

  version = "1.0.6";
  name = "arduino-core";

  src = fetchFromGitHub {
    owner = "arduino";
    repo = "Arduino";
    rev = "${version}";
    sha256 = "0nr5b719qi03rcmx6swbhccv6kihxz3b8b6y46bc2j348rja5332";
  };

  buildInputs = [ jdk ant ];

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
  '';

  meta = {
    description = "Libraries for the open-source electronics prototyping platform";
    homepage = http://arduino.cc/;
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.antono stdenv.lib.maintainers.robberer ];
  }; 
}
