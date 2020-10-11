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
  version = "1.0.3";

  disabled = isPy27;

  # Tests not included in PyPI tarball
  src = fetchFromGitHub {
    owner = "scrapy";
    repo = pname;
    rev = "v${version}";
    sha256 = "1s8c2il7jyfixpb7h5zq0lf4s07pqwia4ycpf3slb8whcp0h8bfm";
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
