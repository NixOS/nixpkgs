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
    sha256 = "0c5xzci1djy1yi9hxxh8g67l6ms8r7ad7ja20pv8hfbdysdrwkhl";
  };

  # Project has no tests
  doCheck = false;
  pythonImportsCheck = [ "mulpyplexer" ];

  meta = {
    description = "Multiplex interactions with lists of Python objects";
    homepage = "https://github.com/zardus/mulpyplexer";
    license = with lib.licenses; [ bsd2 ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
