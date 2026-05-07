{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "proxy-tools";
  version = "0.1.0";
  pyproject = true;

  src = fetchPypi {
    pname = "proxy_tools";
    inherit version;
    hash = "sha256-zLN1H1KcBH4tilhEDYayBTA88P6BRveE0cvNlPCigBA=";
  };

  nativeBuildInputs = [ setuptools ];

  # no tests in pypi
  doCheck = false;
  pythonImportsCheck = [ "proxy_tools" ];

  meta = {
    homepage = "https://github.com/jtushman/proxy_tools";
    description = "Simple (hopefuly useful) Proxy (as in the GoF design pattern) implementation for Python";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ jojosch ];
  };
}
