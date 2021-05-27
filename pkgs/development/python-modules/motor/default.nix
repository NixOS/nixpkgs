{ lib, buildPythonPackage, fetchFromGitHub
, pymongo, mockupdb
}:

buildPythonPackage rec {
  pname = "motor";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "mongodb";
    repo = pname;
    rev = version;
    sha256 = "1sgaqg98h35lazzdi015q1i60ig7krid8b10a5rm6lf755y8yj2c";
  };

  propagatedBuildInputs = [ pymongo ];

  # network connections
  doCheck = false;
  checkInputs = [ mockupdb ];

  pythonImportsCheck = [ "motor" ];

  meta = with lib; {
    description = "Non-blocking MongoDB driver for Tornado or asyncio";
    license = licenses.asl20;
    homepage = "https://github.com/mongodb/motor";
    maintainers = with maintainers; [ globin ];
  };
}
