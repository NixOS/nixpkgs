{ lib
, buildPythonPackage
, fetchPypi
, lark
, nose
, pythonOlder
}:

buildPythonPackage rec {
  pname = "bc-python-hcl2";
  version = "0.4.2";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-rI/1n7m9Q36im4mn18UH/QoelXhFuumurGnyiSuNaB4=";
  };

  # Nose is required during build process, so can not use `nativeCheckInputs`.
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
    description = "Parser for HCL2 written in Python using Lark - an incompatible fork of python-hcl2";
    longDescription = ''
      This parser only supports HCL2 and isn't backwards compatible with HCL v1.
      It can be used to parse any HCL2 config file such as Terraform.

      This is a fork of the Python HCL2 repo by Amplify and is officially supported by Bridgecrew.
      The two projects are now deviating in a way that pushing new changes upstream doesn't make sense anymore.
    '';
    homepage = "https://github.com/bridgecrewio/python-hcl2";
    license = licenses.mit;
    maintainers = with maintainers; [ anhdle14 ];
  };
}
