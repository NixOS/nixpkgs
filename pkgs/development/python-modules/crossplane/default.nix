{ lib, buildPythonPackage, pytestCheckHook, fetchFromGitHub }:

buildPythonPackage rec {
  pname = "crossplane";
  version = "0.5.8";

  src = fetchFromGitHub {
    owner = "nginxinc";
    repo = "crossplane";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-DfIF+JvjIREi7zd5ZQ7Co/CIKC5iUeOgR/VLDPmrtTQ=";
  };

  checkInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "crossplane" ];

  meta = with lib; {
    homepage = "https://github.com/nginxinc/crossplane";
    description = "NGINX configuration file parser and builder";
    license = licenses.asl20;
    maintainers = with maintainers; [ kaction ];
  };
}
