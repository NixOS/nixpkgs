{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pybalboa";
  version = "0.13";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "garbled1";
    repo = pname;
    rev = version;
    sha256 = "0aw5jxpsvzyx05y1mg8d63lxx1i607yb6x19n9jil5wfis95m8pd";
  };

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "pybalboa"
  ];

  meta = with lib; {
    description = " Python module to interface with a Balboa Spa";
    homepage = "https://github.com/garbled1/pybalboa";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
