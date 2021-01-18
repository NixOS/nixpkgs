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
  version = "1.0.4";

  disabled = isPy27;

  # Tests not included in PyPI tarball
  src = fetchFromGitHub {
    owner = "scrapy";
    repo = pname;
    rev = "v${version}";
    sha256 = "0j68xgx2z63sc1nc9clw6744036vfbijdsghvjv6pk674d5lgyam";
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
