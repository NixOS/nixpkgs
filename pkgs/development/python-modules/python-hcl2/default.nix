# A fork is available here: https://github.com/NixOS/nixpkgs/blob/master/pkgs/development/python-modules/bc-python-hcl2/default.nix
# This is the original.

{ buildPythonPackage
, fetchFromGitHub
, lark
, lib
, python
, pythonOlder
, setuptools
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "python-hcl2";
  version = "4.3.2";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "amplify-education";
    repo = "python-hcl2";
    rev = "v${version}";
    hash = "sha256-AsI5JlymwfwyvoLefdPQRg2zks7Hmdea9tYVD1PBpaY=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  # Can not figure out how to make tox happy because:
  # - tox.ini calls pip in the testenv: https://github.com/amplify-education/python-hcl2/blob/e3f1192e5d9e00025c9b88fb3b66b2ad99447aaf/tox.ini#L15
  # - how do we pass the nix python env to tox?
  doCheck = false;

  propagatedBuildInputs = [
    lark
  ];

  pythonImportsCheck = [
    "hcl2"
  ];

  # Generate Lark Parser
  # https://github.com/amplify-education/python-hcl2/blob/e3f1192e5d9e00025c9b88fb3b66b2ad99447aaf/.github/workflows/publish.yml#L19
  preBuild = ''
    ${python.interpreter} hcl2/parser.py
  '';

  meta = with lib; {
    description = "Parser for HCL2 (Terraform config file format) written in Python using Lark";
    longDescription = ''
      This parser only supports HCL2 and isn't backwards compatible with HCL v1.
      It can be used to parse any HCL2 config file such as Terraform.
    '';
    homepage = "https://github.com/amplify-education/python-hcl2";
    license = licenses.mit;
    maintainers = with maintainers; [ danieroux ];
  };
}
