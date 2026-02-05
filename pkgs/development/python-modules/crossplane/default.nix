{
  lib,
  buildPythonPackage,
  pytestCheckHook,
  fetchFromGitHub,
}:

buildPythonPackage rec {
  pname = "crossplane";
  version = "0.5.8";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "nginxinc";
    repo = "crossplane";
    tag = "v${version}";
    hash = "sha256-DfIF+JvjIREi7zd5ZQ7Co/CIKC5iUeOgR/VLDPmrtTQ=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "crossplane" ];

  meta = {
    description = "NGINX configuration file parser and builder";
    mainProgram = "crossplane";
    homepage = "https://github.com/nginxinc/crossplane";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ kaction ];
  };
}
