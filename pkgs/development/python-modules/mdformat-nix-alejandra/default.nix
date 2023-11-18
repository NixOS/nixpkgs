{ lib
, buildPythonPackage
, fetchFromGitHub
, mdformat
, poetry-core
, pythonOlder
}:

buildPythonPackage rec {
  pname = "mdformat-nix-alejandra";
  version = "0.1.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "aldoborrero";
    repo = pname;
    rev = "${version}";
    hash = "sha256-jUXApGsxCA+pRm4m4ZiHWlxmVkqCPx3A46oQdtyKz5g=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  buildInputs = [
    mdformat
  ];

  pythonImportsCheck = [
    "mdformat_nix_alejandra"
  ];

  meta = with lib; {
    description = "Mdformat plugin format Nix code blocks with alejandra";
    homepage = "https://github.com/aldoborrero/mdformat-nix-alejandra";
    license = licenses.mit;
    maintainers = with maintainers; [ aldoborrero ];
  };
}
