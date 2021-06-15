{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, click
, six
}:

buildPythonPackage rec {
  pname = "geomet";
  version = "0.2.1";

  # pypi tarball doesn't include tests
  src = fetchFromGitHub {
    owner = "geomet";
    repo = "geomet";
    rev = version;
    sha256 = "0fdi26glsmrsyqk86rnsfcqw79svn2b0ikdv89pq98ihrpwhn85y";
  };

  patches = [
    (fetchpatch {
      name = "python-3.8-support.patch";
      url = "https://github.com/geomet/geomet/commit/dc4cb4a856d3ad814b57b4b7487d86d9e0f0fad4.patch";
      sha256 = "1f1cdfqyp3z01jdjvax77219l3gc75glywqrisqpd2k0m0g7fwh3";
    })
  ];

  propagatedBuildInputs = [ click six ];

  meta = with lib; {
    homepage = "https://github.com/geomet/geomet";
    license = licenses.asl20;
    description = "Convert GeoJSON to WKT/WKB (Well-Known Text/Binary), and vice versa.";
    maintainers = with maintainers; [ turion ris ];
  };
}
