{ stdenv, fetchurl, buildPythonPackage, minicom, avrdude, arduino_core, avrgcclibc }:

buildPythonPackage {
  name = "ino-0.3.4";
  namePrefix = "";

  src = fetchurl {
    url = "http://pypi.python.org/packages/source/i/ino/ino-0.3.4.tar.gz";
    sha256 = "1v7z3da31cv212k28aci269qkg92p377fm7i76rymjjpjra7payv";
  };

  # TODO: add avrgcclibc, it must be rebuild with C++ support
  propagatedBuildInputs = [ minicom avrdude arduino_core ];

  patchPhase = ''
    echo "Patching Arduino distribution path"
    sed -i 's@/usr/local/share/arduino@${arduino_core}/share/arduino@g' ino/environment.py
  '';
 
  doCheck = false;

  meta = {
    description = "Command line toolkit for working with Arduino hardware";
    homepage = http://inotool.org/;
    license = "MIT";
    maintainers = [ stdenv.lib.maintainers.antono ];
  };
}
