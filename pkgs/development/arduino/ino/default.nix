{ stdenv, fetchurl, buildPythonApplication, pythonPackages, picocom
, avrdude, arduino-core, avrgcclibc }:

buildPythonApplication rec {
  name = "ino-0.3.6";
  namePrefix = "";

  src = fetchurl {
    url = "http://pypi.python.org/packages/source/i/ino/${name}.tar.gz";
    sha256 = "0k6lzfcn55favbj0w4afrvnmwyskf7bgzg9javv2ycvskp35srwv";
  };

  # TODO: add avrgcclibc, it must be rebuild with C++ support
  propagatedBuildInputs =
    [ arduino-core avrdude picocom pythonPackages.configobj
      pythonPackages.jinja2 pythonPackages.pyserial pythonPackages.six ];

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

  meta = {
    description = "Command line toolkit for working with Arduino hardware";
    homepage = http://inotool.org/;
    license = stdenv.lib.licenses.mit;
    maintainers = with stdenv.lib.maintainers; [ antono the-kenny ];
    platforms = stdenv.lib.platforms.linux;
  };
}
