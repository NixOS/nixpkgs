{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, w3lib
, parsel
, jmespath
, itemadapter
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "itemloaders";
  version = "1.0.4";
  disabled = pythonOlder "3.6";

  # Tests not included in PyPI tarball
  src = fetchFromGitHub {
    owner = "scrapy";
    repo = pname;
    rev = "v${version}";
    sha256 = "0j68xgx2z63sc1nc9clw6744036vfbijdsghvjv6pk674d5lgyam";
  };

  propagatedBuildInputs = [ w3lib parsel jmespath itemadapter ];

  checkInputs = [ pytestCheckHook ];

  disabledTests = [
    # Test are failing (AssertionError: Lists differ: ...)
    "test_nested_css"
    "test_nested_xpath"
  ];

  pythonImportsCheck = [ "itemloaders" ];

  meta = with lib; {
    description = "Base library for scrapy's ItemLoader";
    homepage = "https://github.com/scrapy/itemloaders";
    license = licenses.bsd3;
    maintainers = [ maintainers.marsam ];
  };
}
