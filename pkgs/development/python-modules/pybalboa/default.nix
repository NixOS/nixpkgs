{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  poetry-core,
}:

buildPythonPackage rec {
  pname = "pybalboa";
  version = "1.0.2";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "garbled1";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-rSY6kU7F9ybpPXcmTM2WBazjb9tI2+8dG56pjrRXcKg=";
  };

  nativeBuildInputs = [ poetry-core ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "pybalboa" ];

  meta = with lib; {
    description = " Python module to interface with a Balboa Spa";
    homepage = "https://github.com/garbled1/pybalboa";
    changelog = "https://github.com/garbled1/pybalboa/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
