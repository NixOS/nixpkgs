{ lib
, buildPythonPackage
, fetchFromGitHub
, click
, six
}:

buildPythonPackage rec {
  pname = "geomet";
  version = "0.3.0";

  # pypi tarball doesn't include tests
  src = fetchFromGitHub {
    owner = "geomet";
    repo = "geomet";
    rev = version;
    sha256 = "1lb0df78gkivsb7hy3ix0xccvcznvskip11hr5sgq5y76qnfc8p0";
  };

  propagatedBuildInputs = [ click six ];

  meta = with lib; {
    homepage = "https://github.com/geomet/geomet";
    license = licenses.asl20;
    description = "Convert GeoJSON to WKT/WKB (Well-Known Text/Binary), and vice versa.";
    maintainers = with maintainers; [ turion ris ];
  };
}
