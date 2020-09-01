{ lib, buildPythonPackage, fetchPypi, python
, fonttools, lxml, fs, unicodedata2
, defcon, fontpens, fontmath, booleanoperations
, pytest
}:

buildPythonPackage rec {
  pname = "fontParts";
  version = "0.9.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0hwzdppmrrw1xz49x36h6mcsrwya1f3zpqrc206y73j4pbn7fh0k";
    extension = "zip";
  };

  propagatedBuildInputs = [
    booleanoperations
    fonttools
    unicodedata2  # fonttools[unicode] extra
    lxml          # fonttools[lxml] extra
    fs            # fonttools[ufo] extra
    defcon
    fontpens      # defcon[pens] extra
    fontmath
  ];

  checkPhase = ''
    ${python.interpreter} Lib/fontParts/fontshell/test.py
  '';
  checkInputs = [ pytest ];

  meta = with lib; {
    description = "An API for interacting with the parts of fonts during the font development process.";
    homepage = "https://github.com/robotools/fontParts";
    license = licenses.mit;
    maintainers = [ maintainers.sternenseemann ];
  };
}
