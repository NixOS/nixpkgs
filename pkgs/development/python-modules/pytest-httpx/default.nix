{ lib, buildPythonPackage, fetchPypi, httpx, pytest }:

buildPythonPackage rec {
  pname = "pytest-httpx";
  version = "0.11.0";

  src = fetchPypi {
    inherit version;
    pname = "pytest_httpx";
    extension = "tar.gz";
    sha256 = "sha256-koyrYudZfWRYeK4nP9SLGvEd0xlf017FyZ2FN8CV0Ys=";
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
