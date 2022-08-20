{ lib
, buildPythonPackage
, fetchPypi
, lark
, nose
, pythonOlder
}:

buildPythonPackage rec {
  pname = "bc-python-hcl2";
  version = "0.3.45";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-OmUN6wpsVP9/CS+JkEhirDBp1MqeA3oEcU77T5nJ9GU=";
  };

  # Nose is required during build process, so can not use `checkInputs`.
  buildInputs = [
    nose
  ];

  propagatedBuildInputs = [
    lark
  ];

  # This fork of python-hcl2 doesn't ship tests
  doCheck = false;

  pythonImportsCheck = [
    "hcl2"
  ];

  meta = with lib; {
    description = "Parser for HCL2 written in Python using Lark";
    longDescription = ''
      This parser only supports HCL2 and isn't backwards compatible with HCL v1.
      It can be used to parse any HCL2 config file such as Terraform.
    '';
    # Although this is the main homepage from PyPi but it is also a homepage
    # of another PyPi package (python-hcl2). But these two are different.
    homepage = "https://github.com/amplify-education/python-hcl2";
    license = licenses.mit;
    maintainers = with maintainers; [ anhdle14 ];
  };
}
