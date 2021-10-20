{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, requests
}:

buildPythonPackage rec {
  pname = "pdunehd";
  version = "1.3.2";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "valentinalexeev";
    repo = "pdunehd";
    rev = version;
    sha256 = "06p0k82nf89rsakr8d2hdb19dp1wqp9bsf54lwb0qma47iakljjh";
  };

  propagatedBuildInputs = [
    requests
  ];

  # no tests implemented
  doCheck = false;

  pythonImportsCheck = [ "pdunehd" ];

  meta = with lib; {
    description = "Python wrapper for Dune HD media player API";
    homepage = "https://github.com/valentinalexeev/pdunehd";
    license = licenses.asl20;
    maintainers = with maintainers; [ dotlambda ];
  };
}
