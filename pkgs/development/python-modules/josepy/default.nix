{
  lib,
  buildPythonPackage,
  cryptography,
  fetchPypi,
  fetchpatch,
  poetry-core,
  pyopenssl,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "josepy";
  version = "1.14.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-MIs7+c6CWtTUu6djcs8ZtdwcLOlqnSmPlkKXXmS9E90=";
  };

  patches = [
    # don't fail tests on openssl deprecation warning, upstream is working on proper fix
    # FIXME: remove for next update
    (fetchpatch {
      url = "https://github.com/certbot/josepy/commit/350410fc1d38c4ac8422816b6865ac8cd9c60fc7.diff";
      hash = "sha256-QGbzonXb5BtTTWDeDqnZhbS6gHce99vIOm/H8QYeGXY=";
    })
  ];

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    pyopenssl
    cryptography
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "josepy" ];

  meta = with lib; {
    changelog = "https://github.com/certbot/josepy/blob/v${version}/CHANGELOG.rst";
    description = "JOSE protocol implementation in Python";
    mainProgram = "jws";
    homepage = "https://github.com/certbot/josepy";
    license = licenses.asl20;
    maintainers = with maintainers; [ dotlambda ];
  };
}
