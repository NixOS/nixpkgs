{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, ctranslate2
, ctranslate2-cpp
, sentencepiece
, stanza
}:
let
  ctranslate2OneDNN = ctranslate2.override {
    ctranslate2-cpp = ctranslate2-cpp.override {
      # https://github.com/OpenNMT/CTranslate2/issues/1294
      withOneDNN = true;
      withOpenblas = false;
    };
  };
in
buildPythonPackage rec {
  pname = "argostranslate";
  version = "1.9.1";

  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-OlVrRfBhbJpIFjWdLQsn7zEteRP6UfkIpGT4Y933QKk=";
  };

  propagatedBuildInputs = [
    ctranslate2OneDNN
    sentencepiece
    stanza
  ];

  postPatch = ''
    ln -s */requires.txt requirements.txt

    substituteInPlace requirements.txt  \
      --replace "==" ">="
  '';

  doCheck = false; # needs network access

  nativeCheckInputs = [
    pytestCheckHook
  ];

  # required for import check to work
  # PermissionError: [Errno 13] Permission denied: '/homeless-shelter'
  env.HOME = "/tmp";

  pythonImportsCheck = [
    "argostranslate"
    "argostranslate.translate"
  ];

  meta = with lib; {
    description = "Open-source offline translation library written in Python";
    homepage = "https://www.argosopentech.com";
    license = licenses.mit;
    maintainers = with maintainers; [ misuzu ];
  };
}
