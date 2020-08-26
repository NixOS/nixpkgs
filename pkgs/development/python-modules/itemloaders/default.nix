{ lib
, buildPythonPackage
, fetchFromGitHub
, isPy27
, w3lib
, parsel
, jmespath
, itemadapter
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "itemloaders";
  version = "1.0.1";

  disabled = isPy27;

  # Tests not included in PyPI tarball
  src = fetchFromGitHub {
    owner = "scrapy";
    repo = pname;
    rev = "v${version}";
    sha256 = "0frs0s876ddha844vhnhhiggyk3qbhhngrwkvgg3c0mrnn282f6k";
  };

  propagatedBuildInputs = [ w3lib parsel jmespath itemadapter ];

  checkInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Base library for scrapy's ItemLoader";
    homepage = "https://github.com/scrapy/itemloaders";
    license = licenses.bsd3;
    maintainers = [ maintainers.marsam ];
  };
}
