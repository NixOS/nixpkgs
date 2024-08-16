{
  lib,
  buildPythonPackage,
  pytestCheckHook,
  fetchFromGitHub,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "crossplane";
  version = "0.5.8";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "nginxinc";
    repo = "crossplane";
    rev = "refs/tags/v${version}";
    hash = "sha256-DfIF+JvjIREi7zd5ZQ7Co/CIKC5iUeOgR/VLDPmrtTQ=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "crossplane" ];

  meta = with lib; {
    description = "NGINX configuration file parser and builder";
    mainProgram = "crossplane";
    homepage = "https://github.com/nginxinc/crossplane";
    license = licenses.asl20;
    maintainers = with maintainers; [ kaction ];
  };
}
