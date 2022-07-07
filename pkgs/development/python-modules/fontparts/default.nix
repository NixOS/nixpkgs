{ lib, buildPythonPackage, fetchPypi, python, pythonOlder
, fonttools, lxml, fs, unicodedata2
, defcon, fontpens, fontmath, booleanoperations
, pytest, setuptools-scm
}:

buildPythonPackage rec {
  pname = "fontParts";
  version = "0.10.6";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-mEnQWmzzZ5S8rWzmXuJDjcuoICi6Q+aneX8hGXj11Gg=";
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
    changelog = "https://github.com/robotools/fontParts/releases/tag/${version}";
    license = licenses.mit;
    maintainers = [ maintainers.sternenseemann ];
  };
}
