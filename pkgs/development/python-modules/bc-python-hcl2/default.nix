{ lib, buildPythonPackage, fetchPypi, nose }:

let
  lark-parser = buildPythonPackage rec {
    pname = "lark-parser";
    version = "0.7.8";

    src = fetchPypi {
      inherit pname version;
      sha256 = "JiFeuxV+b7LudDGapERbnzt+RW4mviFc4Z/aqpAcIKQ=";
    };

    doCheck = true;
  };
in
buildPythonPackage rec {
  pname = "bc-python-hcl2";
  version = "0.3.11";

  src = fetchPypi {
    inherit pname version;
    sha256 = "VZhI1oJ2EDZGyz3iI6/KYvJq4BGafzR+rcSgHqlUDrA=";
  };

  # Nose is required during build process, so can not use `checkInputs`.
  buildInputs = [
    nose
  ];

  propagatedBuildInputs = [
    lark-parser
  ];

  pythonImportsCheck = [ "hcl2" ];

  meta = with lib; {
    description = "A parser for HCL2 written in Python using Lark";
    longDescription = ''
    A parser for HCL2 written in Python using Lark.
    This parser only supports HCL2 and isn't backwards compatible with HCL v1.
    It can be used to parse any HCL2 config file such as Terraform.
    '';
    # Although this is the main homepage from PyPi but it is also a homepage
    # of another PyPi package (python-hcl2). But these two are different.
    homepage = "https://github.com/amplify-education/python-hcl2";
    license = licenses.mit;
    maintainers = [ maintainers.anhdle14 ];
  };
}
