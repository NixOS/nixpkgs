{
  lib,
  buildPythonPackage,
  fetchPypi,
  h2,
  pyjwt,
  pyopenssl,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "aioapns";
  version = "3.3";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-lLlfrv9yHBHKqmSrs4y9NKMgGSGQQe+zVFWMht+MvGk=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    h2
    pyopenssl
    pyjwt
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "aioapns" ];

  meta = with lib; {
    description = "Efficient APNs Client Library";
    homepage = "https://github.com/Fatal1ty/aioapns";
    changelog = "https://github.com/Fatal1ty/aioapns/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
