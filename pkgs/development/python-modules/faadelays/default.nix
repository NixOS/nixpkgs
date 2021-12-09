{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
}:

buildPythonPackage rec {
  pname = "faadelays";
  version = "0.0.7";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
     owner = "ntilley905";
     repo = "faadelays";
     rev = "v0.0.7";
     sha256 = "1jhwb3qcwa18q4gm0b5h6bnd9l4drqm89ngw9s093spz7a664q1n";
  };

  propagatedBuildInputs = [ aiohttp ];

  # Project has no tests
  doCheck = false;
  pythonImportsCheck = [ "faadelays" ];

  meta = with lib; {
    description = "Python package to retrieve FAA airport status";
    homepage = "https://github.com/ntilley905/faadelays";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
