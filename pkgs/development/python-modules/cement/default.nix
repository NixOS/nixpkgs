{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "cement";
  version = "3.0.10";
  format = "setuptools";

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-c9EBXr+bjfE+a8mH7fDUvj8ci0Q4kh7qjWbLtVBK7hU=";
  };

  # Disable test tests since they depend on a memcached server running on
  # 127.0.0.1:11211.
  doCheck = false;

  pythonImportsCheck = [ "cement" ];

  meta = with lib; {
    description = "CLI Application Framework for Python";
    mainProgram = "cement";
    homepage = "https://builtoncement.com/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ eqyiel ];
  };
}
