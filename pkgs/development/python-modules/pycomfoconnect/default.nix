{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  protobuf,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pycomfoconnect";
  version = "0.5.1";
  format = "setuptools";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "michaelarnauts";
    repo = "comfoconnect";
    tag = version;
    hash = "sha256-I/0vCgSEi6mgYg1fMH4Ha7PoonewtqYYsvXZT8y4rJE=";
  };

  propagatedBuildInputs = [ protobuf ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "pycomfoconnect" ];

  meta = with lib; {
    description = "Python module to interact with ComfoAir Q350/450/600 units";
    homepage = "https://github.com/michaelarnauts/comfoconnect";
    changelog = "https://github.com/michaelarnauts/comfoconnect/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
