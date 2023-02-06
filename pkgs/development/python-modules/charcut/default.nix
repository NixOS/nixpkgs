{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
}:

buildPythonPackage
rec {
  pname = "charcut";
  version = "1.1.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-oWmszWGvvFF1to/AKQXV2iBFAUIIL6Fxk0xV3CgS1qs=";
  };

  propagatedBuildInputs = [
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "charcut"
  ];

  meta = with lib; {
    description = "Character-based MT evaluation and difference highlighting";
    homepage = "https://github.com/BramVanroy/CharCut";
    license = licenses.gpl3;
    maintainers = with maintainers; [ YodaEmbedding ];
  };
}
