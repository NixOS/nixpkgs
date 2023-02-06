{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, levenshtein
}:

buildPythonPackage
rec {
  pname = "cer";
  version = "1.2.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-SFy36i5suvyu0hR5Bb0Gw6VFPLqOWY/ltZdsYlulkE4=";
  };

  propagatedBuildInputs = [
    levenshtein
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "cer"
  ];

  meta = with lib; {
    description = "CharacTER: Translation Edit Rate on Character Level";
    homepage = "https://github.com/BramVanroy/CharacTER";
    license = licenses.gpl3;
    maintainers = with maintainers; [ YodaEmbedding ];
  };
}
