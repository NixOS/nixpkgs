{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "deluge-client";
  version = "1.10.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-OIGu48Tgyp3YpWtxAEe4N+HQh6g+QhY2oHR3H5Kp8bU=";
  };

  nativeBuildInputs = [ setuptools ];

  # it will try to connect to a running instance
  doCheck = false;

  pythonImportsCheck = [ "deluge_client" ];

  meta = with lib; {
    description = "Lightweight pure-python rpc client for deluge";
    homepage = "https://github.com/JohnDoee/deluge-client";
    changelog = "https://github.com/JohnDoee/deluge-client/blob/${version}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
