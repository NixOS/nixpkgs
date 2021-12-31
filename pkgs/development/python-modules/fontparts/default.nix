{ lib, buildPythonPackage, fetchPypi, python
, fonttools, lxml, fs, unicodedata2
, defcon, fontpens, fontmath, booleanoperations
, pytest, setuptools-scm
}:

buildPythonPackage rec {
  pname = "fontParts";
  version = "0.10.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "794ada47e19ba41ef39b59719be312b127672bcb56bb7208dd3234d2bb3e8218";
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
