{ buildPythonPackage, fetchPypi, lib }:

buildPythonPackage rec {
  pname = "packageurl-python";
  version = "0.9.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0mpvj8imsaqhrgfq1cxx16flc5201y78kqa7bh2i5zxsc29843mx";
  };

  meta = with lib; {
    description = "A parser and builder for purl aka 'Package URLs' for Python 2 and 3.";
    homepage = "https://github.com/package-url/packageurl-python";
    license = licenses.mit;
    maintainers = with maintainers; [ armijnhemel ];
  };
}
