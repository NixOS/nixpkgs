{ lib
, buildPythonPackage
, fetchFromGitHub
, cython
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "cymem";
  version = "2.0.7";

  src = fetchFromGitHub {
    owner = "explosion";
    repo = "cymem";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-lYMRFFMS+ETjWd4xi12ezC8CVLbLJfynmOU1DpYQcck=";
  };

  propagatedBuildInputs = [
    cython
  ];

  checkInputs = [
    pytestCheckHook
  ];

  preCheck = ''
    TEMPDIR=$(mktemp -d)
    cp -R cymem/tests $TEMPDIR/
    pushd $TEMPDIR
  '';

  postCheck = ''
    popd
  '';


  meta = with lib; {
    description = "Cython memory pool for RAII-style memory management";
    homepage = "https://github.com/explosion/cymem";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
