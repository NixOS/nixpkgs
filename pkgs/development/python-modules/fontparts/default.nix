{ lib, buildPythonPackage, fetchPypi, python
, fonttools, lxml, fs, unicodedata2
, defcon, fontpens, fontmath, booleanoperations
, pytest, setuptools-scm
}:

buildPythonPackage rec {
  pname = "fontParts";
  version = "0.9.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0hwjnqbkcfkhigx581w4532vddsx5wiy73gx46kjisp0hlir9628";
    extension = "zip";
  };

  nativeBuildInputs = [ setuptools-scm ];

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
    runHook preCheck
    ${python.interpreter} Lib/fontParts/fontshell/test.py
    runHook postCheck
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
