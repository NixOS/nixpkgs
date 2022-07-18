{ lib, buildPythonPackage, pytestCheckHook, fetchFromGitHub }:

buildPythonPackage rec {
  pname = "crossplane";
  version = "0.5.7";

  src = fetchFromGitHub {
    owner = "nginxinc";
    repo = "crossplane";
    rev = "v${version}";
    sha256 = "0lv3frfvnvz5wjxwh3mwy8nbypv4i62v4bvy5fv7vd6kmbxy1q9l";
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
