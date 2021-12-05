{ lib, buildPythonPackage, fetchFromGitHub, simpleeval, pythonOlder, coveralls
, wcmatch }:

buildPythonPackage rec {
  pname = "casbin";
  version = "1.12.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = pname;
    repo = "pycasbin";
    rev = "v${version}";
    sha256 = "sha256-kUM4Oc4T3PSFAprUx6eY/aJpDM8RiHjPtAxMKjfHj6s=";
  };

  propagatedBuildInputs = [ simpleeval wcmatch ];

  checkInputs = [ coveralls ];

  checkPhase = ''
    coverage run -m unittest discover -s tests -t tests
  '';

  pythonImportsCheck = [ "casbin" ];

  meta = with lib; {
    description =
      "An authorization library that supports access control models like ACL, RBAC, ABAC in Python";
    homepage = "https://github.com/casbin/pycasbin";
    license = licenses.asl20;
    maintainers = with maintainers; [ costrouc ];
  };
}
