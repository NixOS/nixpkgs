{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  pyyaml,
  six,
  lxml,
}:

buildPythonPackage rec {
  pname = "ipyxact";
  version = "0.3.2";
  format = "setuptools";

  propagatedBuildInputs = [ pyyaml ];
  checkInputs = [
    six
    lxml
  ];

  src = fetchFromGitHub {
    owner = "olofk";
    repo = "ipyxact";
    rev = "v${version}";
    hash = "sha256-myD+NnqcxxaSAV7qZa8xqeciaiFqFePqIzd7sb/2GXA=";
  };

  pythonImportsCheck = [ "ipyxact" ];

  meta = {
    homepage = "https://github.com/olofk/ipyxact";
    description = "IP-XACT parser";
    mainProgram = "ipxact2v";
    maintainers = with lib.maintainers; [ genericnerdyusername ];
    license = lib.licenses.mit;
  };
}
