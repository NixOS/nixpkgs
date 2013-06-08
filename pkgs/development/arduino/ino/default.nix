{ stdenv, fetchurl, buildPythonPackage, pythonPackages, minicom
, avrdude, arduino_core, avrgcclibc }:

buildPythonPackage {
  name = "ino-0.3.4";
  namePrefix = "";

  src = fetchurl {
    url = "http://pypi.python.org/packages/source/i/ino/ino-0.3.4.tar.gz";
    sha256 = "1v7z3da31cv212k28aci269qkg92p377fm7i76rymjjpjra7payv";
  };

  # TODO: add avrgcclibc, it must be rebuild with C++ support
  propagatedBuildInputs =
    [ arduino_core avrdude minicom pythonPackages.configobj
      pythonPackages.jinja2 pythonPackages.pyserial ];

  patchPhase = ''
    echo "Patching Arduino distribution path"
    sed -i 's@/usr/local/share/arduino@${arduino_core}/share/arduino@g' \
        ino/environment.py
    sed -i -e 's@argparse@@' -e 's@ordereddict@@' \
        requirements.txt
    sed -i -e 's@from ordereddict@from collections@' \
        ino/environment.py ino/utils.py
  '';
 
  meta = {
    description = "Command line toolkit for working with Arduino hardware";
    homepage = http://inotool.org/;
    license = "MIT";
    maintainers = [ stdenv.lib.maintainers.antono ];
  };
}
