{
  lib,
  buildPythonPackage,
  fetchPypi,
  isPy27,
  requests,
  six,
  pytestCheckHook,
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
    sha256 = "8a8f867e1f27762a28a0832c33c6003ca54ee04c935678d124b4c071f7cf5a1f";
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
