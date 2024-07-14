{
  lib,
  buildPythonPackage,
  fetchPypi,
  isPy27,
  requests,
  six,
  pytestCheckHook,
  pythonOlder,
  requests-toolbelt,
  responses,
}:

buildPythonPackage rec {
  pname = "pushover-complete";
  version = "1.1.1";
  format = "setuptools";
  disabled = isPy27;

  src = fetchPypi {
    pname = "pushover_complete";
    inherit version;
    hash = "sha256-io+Gfh8ndioooIMsM8YAPKVO4EyTVnjRJLTAcffPWh8=";
  };

  propagatedBuildInputs = [
    requests
    six
  ];

  nativeCheckInputs = [
    pytestCheckHook
    requests-toolbelt
    responses
  ];

  pythonImportsCheck = [ "pushover_complete" ];

  meta = with lib; {
    description = "Python package for interacting with *all* aspects of the Pushover API";
    homepage = "https://github.com/scolby33/pushover_complete";
    license = licenses.mit;
    maintainers = [ maintainers.mic92 ];
  };
}
