{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
}:

buildPythonPackage rec {
  pname = "itemdb";
  version = "1.2.0";
  format = "setuptools";

  # PyPI tarball doesn't include tests directory
  src = fetchFromGitHub {
    owner = "almarklein";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-egxQ1tGC6R5p1stYm4r05+b2HkuT+nBySTZPGqeAbSE=";
  };

  meta = with lib; {
    description = "Easy transactional database for Python dicts, backed by SQLite";
    license = licenses.bsd2;
    homepage = "https://itemdb.readthedocs.io";
    maintainers = [ maintainers.matthiasbeyer ];
  };
}
