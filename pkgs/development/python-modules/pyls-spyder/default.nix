{ lib
, buildPythonPackage
, fetchFromGitHub
, python-lsp-server
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pyls-spyder";
  version = "0.4.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "spyder-ide";
    repo = pname;
    rev = "v${version}";
    sha256 = "11ajbsia60d4c9s6m6rbvaqp1d69fcdbq6a98lkzkkzv2b9pdhkk";
  };

  propagatedBuildInputs = [
    python-lsp-server
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pyls_spyder" ];

  meta = with lib; {
    description = "Spyder extensions for the python-language-server";
    homepage = "https://github.com/spyder-ide/pyls-spyder";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
