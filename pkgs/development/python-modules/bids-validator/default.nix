{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,

  # build-system
  setuptools,
  versioneer,
}:

buildPythonPackage rec {
  pname = "bids-validator";
  version = "1.14.6";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "bids_validator";
    inherit version;
    hash = "sha256-3ytrXRqq1h00zK0ElPLtc84wgoJa2jGVTE4UwlONSFw=";
  };

  nativeBuildInputs = [
    setuptools
    versioneer
  ];

  # needs packages which are not available in nixpkgs
  doCheck = false;

  pythonImportsCheck = [ "bids_validator" ];

  meta = with lib; {
    description = "Validator for the Brain Imaging Data Structure";
    homepage = "https://github.com/bids-standard/bids-validator";
    changelog = "https://github.com/bids-standard/bids-validator/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = [ ];
  };
}
