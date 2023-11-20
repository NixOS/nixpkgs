{ lib
, buildPythonPackage
, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "itemdb";
  version = "1.1.2";

  # PyPI tarball doesn't include tests directory
  src = fetchFromGitHub {
    owner = "almarklein";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-s7a+MJLTAcGv2rYRMO2SAlsDYen6Si10qUQOVDFuf6c=";
  };

  meta = with lib; {
    description = "Easy transactional database for Python dicts, backed by SQLite";
    license = licenses.bsd2;
    homepage = "https://itemdb.readthedocs.io";
    maintainers = [ maintainers.matthiasbeyer ];
  };
}


