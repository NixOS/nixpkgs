{ lib, buildPythonPackage, fetchPypi, python
, fonttools, lxml, fs, unicodedata2
, defcon, fontpens, fontmath, booleanoperations
, pytest, setuptools_scm
}:

buildPythonPackage rec {
  pname = "fontParts";
  version = "0.9.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "183y1y11bqd4ky4anyv40qbvsm6i90gnydqzrjg7syspjsqvfqgy";
    extension = "zip";
  };

  nativeBuildInputs = [ setuptools_scm ];

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
    changelog = "https://github.com/robotools/fontParts/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = [ maintainers.sternenseemann ];
  };
}
