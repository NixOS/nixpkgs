{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  lark,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "bc-python-hcl2";
  version = "0.4.3";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "bridgecrewio";
    repo = "python-hcl2";
    tag = version;
    hash = "sha256-Auk5xDLw2UhMzWa7YMKzwUSjhD9s6xHt8RcXMzzL8M0=";
  };

  build-system = [ setuptools ];

  dependencies = [ lark ];

  # This fork of python-hcl2 doesn't ship tests
  doCheck = false;

  pythonImportsCheck = [ "hcl2" ];

  meta = with lib; {
    description = "Parser for HCL2 written in Python using Lark";
    longDescription = ''
      This parser only supports HCL2 and isn't backwards compatible with HCL v1.
      It can be used to parse any HCL2 config file such as Terraform.
    '';
    homepage = "https://github.com/bridgecrewio/python-hcl2";
    license = licenses.mit;
    maintainers = with maintainers; [ anhdle14 ];
    mainProgram = "hcl2tojson";
  };
}
