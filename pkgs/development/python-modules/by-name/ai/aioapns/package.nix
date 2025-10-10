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
  version = "4.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-NxX6q/P6bAJA52N/RCfYjQiv3M6w3PuVbG0JtvSUJ/g=";
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
    maintainers = [ ];
  };
}
