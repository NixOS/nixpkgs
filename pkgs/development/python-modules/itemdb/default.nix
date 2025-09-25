{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
}:

buildPythonPackage rec {
  pname = "itemdb";
  version = "1.3.0";
  format = "pyproject";

  nativeBuildInputs = [
    flit-core
  ];

  # PyPI tarball doesn't include tests directory
  src = fetchFromGitHub {
    owner = "almarklein";
    repo = "itemdb";
    tag = "v${version}";
    sha256 = "sha256-HXdOERq2td6CME8zWN0DRVkSlmdqTg2po7aJrOuITHE=";
  };

  meta = with lib; {
    description = "Easy transactional database for Python dicts, backed by SQLite";
    license = licenses.bsd2;
    homepage = "https://itemdb.readthedocs.io";
    maintainers = [ maintainers.matthiasbeyer ];
  };
}
