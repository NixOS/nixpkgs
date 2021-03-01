{ lib, buildPythonPackage, fetchPypi, isPy27 }:

buildPythonPackage rec {
  pname = "itemadapter";
  version = "0.2.0";

  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "cb7aaa577fefe2aa6f229ccf4d058e05f44e0178a98c8fb70ee4d95acfabb423";
  };

  doCheck = false; # infinite recursion with Scrapy

  pythonImportsCheck = [ "itemadapter" ];

  meta = with lib; {
    description = "Common interface for data container classes";
    homepage = "https://github.com/scrapy/itemadapter";
    license = licenses.bsd3;
    maintainers = [ maintainers.marsam ];
  };
}
