{ lib
, requests
, buildPythonPackage
, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "aladdin-connect";
  version = "0.4";

  src = fetchFromGitHub {
    owner = "shoejosh";
    repo = pname;
    rev = version;
    sha256 = "sha256-kLvMpSGa5WyDOH3ejAJyFGsB9IiMXp+nvVxM/ZkxyFw=";
  };

  propagatedBuildInputs = [
    requests
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "aladdin_connect" ];

  meta = with lib; {
    description = "Python library for interacting with Genie Aladdin Connect devices";
    homepage = "https://github.com/shoejosh/aladdin-connect";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
