{ lib, buildPythonPackage, fetchPypi, httpx, pytest }:

buildPythonPackage rec {
  pname = "pytest-httpx";
  version = "0.10.1";

  src = fetchPypi {
    inherit version;
    pname = "pytest_httpx";
    extension = "tar.gz";
    sha256 = "13ld6nnsc3f7i4zl4qm1jh358z0awr6xfk05azwgngmjb7jmcz0a";
  };

  propagatedBuildInputs = [ httpx pytest ];

  # not in pypi tarball
  doCheck = false;
  pythonImportsCheck = [ "pytest_httpx" ];

  meta = with lib; {
    description = "Send responses to httpx";
    homepage = "https://github.com/Colin-b/pytest_httpx";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
