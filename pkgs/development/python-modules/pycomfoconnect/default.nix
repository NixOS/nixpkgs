{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  protobuf,
}:

buildPythonPackage rec {
  pname = "pycomfoconnect";
  version = "0.5.1";
  format = "setuptools";

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

  meta = {
    description = "Python module to interact with ComfoAir Q350/450/600 units";
    homepage = "https://github.com/michaelarnauts/comfoconnect";
    changelog = "https://github.com/michaelarnauts/comfoconnect/releases/tag/${version}";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
