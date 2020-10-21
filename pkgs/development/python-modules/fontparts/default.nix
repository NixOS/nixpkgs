{ lib, buildPythonPackage, fetchPypi, python
, fonttools, lxml, fs, unicodedata2
, defcon, fontpens, fontmath, booleanoperations
, pytest
}:

buildPythonPackage rec {
  pname = "fontParts";
  version = "0.9.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0q8ilc1ypmasci2x1nq69hnfsnvbi1czaxgsb3zgqd8777bn5v9z";
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
    changelog = "https://github.com/robotools/fontParts/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = [ maintainers.sternenseemann ];
  };
}
