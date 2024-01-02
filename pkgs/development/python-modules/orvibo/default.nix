{ lib
, buildPythonPackage
, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "orvibo";
  version = "1.1.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "happyleavesaoc";
    repo = "python-orvibo";
    rev = version;
    sha256 = "042prd5yxqvlfija7ii1xn424iv1p7ndhxv6m67ij8cbvspwx356";
  };

  # Project as no tests
  doCheck = false;
  pythonImportsCheck = [ "orvibo" ];

  meta = with lib; {
    description = "Python client to work with Orvibo devices";
    homepage = "https://github.com/happyleavesaoc/python-orvibo";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
