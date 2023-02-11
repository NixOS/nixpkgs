{ lib
, buildPythonPackage
, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "itemdb";
  version = "1.1.1";

  # PyPI tarball doesn't include tests directory
  src = fetchFromGitHub {
    owner = "almarklein";
    repo = pname;
    rev = "v${version}";
    sha256 = "0ksad5j91nlbsn0a11clf994qz7r9ijand5hxnjhgd66i9hl3y78";
  };

  meta = with lib; {
    description = "Easy transactional database for Python dicts, backed by SQLite";
    license = licenses.bsd2;
    homepage = "https://itemdb.readthedocs.io";
    maintainers = [ maintainers.matthiasbeyer ];
  };
}


