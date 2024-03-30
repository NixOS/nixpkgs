{ lib
, buildPythonPackage
, fetchPypi
, defcon
, fonttools
, gflanguages
, glyphslib
, pytestCheckHook
, requests
, setuptools
, setuptools-scm
, unicodedata2
}:

buildPythonPackage rec {
  pname = "glyphsets";
  version = "0.6.14";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-lMRgchadgKyfFLw6ZF1sJAKBAK75zmw77L34MW9p7TI=";
  };

  propagatedBuildInputs = [
    defcon
    fonttools
    gflanguages
    glyphslib
    requests
    setuptools
    unicodedata2
  ];
  nativeBuildInputs = [
    setuptools-scm
  ];

  doCheck = true;
  nativeCheckInputs = [
    pytestCheckHook
  ];
  preCheck = ''
    export PATH="$out/bin:$PATH"
  '';

  meta = with lib; {
    description = "Google Fonts glyph set metadata";
    mainProgram = "glyphsets";
    homepage = "https://github.com/googlefonts/glyphsets";
    license = licenses.asl20;
    maintainers = with maintainers; [ danc86 ];
  };
}
