{ lib, fetchurl, python2Packages, picocom
, avrdude, arduino-core }:

python2Packages.buildPythonApplication rec {
  pname = "ino";
  version = "0.3.6";

  src = fetchurl {
    url = "mirror://pypi/i/ino/ino-${version}.tar.gz";
    sha256 = "0k6lzfcn55favbj0w4afrvnmwyskf7bgzg9javv2ycvskp35srwv";
  };

  # TODO: add avrgcclibc, it must be rebuild with C++ support
  propagatedBuildInputs = with python2Packages; [
    arduino-core
    avrdude
    picocom
    configobj
    jinja2
    pyserial
    six
  ];

  patchPhase = ''
    echo "Patching Arduino distribution path"
    sed -i 's@/usr/local/share/arduino@${arduino-core}/share/arduino@g' \
        ino/environment.py
    sed -i -e 's@argparse@@' -e 's@ordereddict@@' \
        requirements.txt
    sed -i -e 's@from ordereddict@from collections@' \
        ino/environment.py ino/utils.py

    # Patch the upload command so it uses the correct avrdude
    substituteInPlace ino/commands/upload.py \
      --replace "self.e['avrdude']" "'${avrdude}/bin/avrdude'" \
      --replace "'-C', self.e['avrdude.conf']," ""
  '';

  meta = with lib; {
    description = "Command line toolkit for working with Arduino hardware";
    homepage = "http://inotool.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ antono ];
    platforms = platforms.linux;
  };
}
