{
  lib,
  alejandra,
  buildPythonPackage,
  fetchFromGitHub,
  mdformat,
  poetry-core,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "mdformat-nix-alejandra";
  version = "0.1.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "aldoborrero";
    repo = "mdformat-nix-alejandra";
    rev = "refs/tags/${version}";
    hash = "sha256-jUXApGsxCA+pRm4m4ZiHWlxmVkqCPx3A46oQdtyKz5g=";
  };

  postPatch = ''
    substituteInPlace mdformat_nix_alejandra/__init__.py \
      --replace-fail '"alejandra"' '"${lib.getExe alejandra}"'
  '';

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [ mdformat ];

  pythonImportsCheck = [ "mdformat_nix_alejandra" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Mdformat plugin format Nix code blocks with alejandra";
    homepage = "https://github.com/aldoborrero/mdformat-nix-alejandra";
    license = licenses.mit;
    maintainers = with maintainers; [ aldoborrero ];
  };
}
