{ lib, buildPythonPackage, fetchPypi, python
, fonttools, lxml, fs, unicodedata2
, defcon, fontpens, fontmath, booleanoperations
, pytest, setuptools-scm
}:

buildPythonPackage rec {
  pname = "fontParts";
  version = "0.10.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a3a3926e977f82ae19e6823760b59f2338085973da1eaad5badaf969f261a737";
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
