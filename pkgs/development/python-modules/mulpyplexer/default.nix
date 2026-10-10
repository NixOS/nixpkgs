{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "mulpyplexer";
  version = "0.09";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-FE6em/ZtOYj2BULJ09TJSFdDj3kI9g5T9MHLFiL7vTA=";
  };

  # Project has no tests
  doCheck = false;
  pythonImportsCheck = [ "mulpyplexer" ];

  meta = {
    description = "Multiplex interactions with lists of Python objects";
    homepage = "https://github.com/zardus/mulpyplexer";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ fab ];
  };
}
