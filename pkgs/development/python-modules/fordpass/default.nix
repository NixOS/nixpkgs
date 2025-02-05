{
  lib,
  requests,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "fordpass";
  version = "0.0.4";
  format = "setuptools";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "clarkd";
    repo = "fordpass-python";
    rev = version;
    sha256 = "0i1dlswxc2bv1smc5d4r1adbxbl7sgr1swh2cjfajp73vs43xa0m";
  };

  propagatedBuildInputs = [ requests ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "fordpass" ];

  meta = with lib; {
    description = "Python module for the FordPass API";
    mainProgram = "demo.py";
    homepage = "https://github.com/clarkd/fordpass-python";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
