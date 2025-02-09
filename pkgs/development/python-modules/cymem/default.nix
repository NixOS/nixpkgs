{ lib
, buildPythonPackage
, fetchFromGitHub
, cython
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "cymem";
  version = "2.0.8";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "explosion";
    repo = "cymem";
    rev = "refs/tags/v${version}";
    hash = "sha256-e4lgV39lwC2Goqmd8Jjra+znuCpxsv2IsRXfFbQkGN8=";
  };

  propagatedBuildInputs = [
    cython
  ];

  nativeCheckInputs = [
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

  pythonImportsCheck = [
    "cymem"
  ];

  meta = with lib; {
    description = "Cython memory pool for RAII-style memory management";
    homepage = "https://github.com/explosion/cymem";
    changelog = "https://github.com/explosion/cymem/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
