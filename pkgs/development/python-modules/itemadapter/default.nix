{ lib, buildPythonPackage, fetchPypi, isPy27 }:

buildPythonPackage rec {
  pname = "itemadapter";
  version = "0.3.0";

  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "ab2651ba20f5f6d0e15f041deba4c13ffc59270def2bd01518d13e94c4cd27d1";
  };

  doCheck = false; # infinite recursion with Scrapy

  pythonImportsCheck = [ "itemadapter" ];

  meta = with lib; {
    description = "Common interface for data container classes";
    homepage = "https://github.com/scrapy/itemadapter";
    changelog = "https://github.com/scrapy/itemadapter/raw/v${version}/Changelog.md";
    license = licenses.bsd3;
    maintainers = [ maintainers.marsam ];
  };
}
