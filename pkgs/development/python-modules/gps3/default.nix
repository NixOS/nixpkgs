{ lib
, buildPythonPackage
, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "gps3";
  version = "0.33.3";

  src = fetchFromGitHub {
    owner = "onkelbeh";
    repo = pname;
    rev = version;
    sha256 = "0a0qpk7d2b1cld58qcdn6bxrkil6ascs51af01dy4p83062h1hi6";
  };

  # Project has no tests
  doCheck = false;
  pythonImportsCheck = [ "gps3" ];

  meta = with lib; {
    description = "Python client for GPSD";
    homepage = "https://github.com/onkelbeh/gps3";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
