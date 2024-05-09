{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "exrex";
  version = "0.11.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "asciimoo";
    repo = "exrex";
    # https://github.com/asciimoo/exrex/issues/68
    rev = "239e4da37ff3a66d8b4b398d189299ae295594c3";
    hash = "sha256-Tn/XIIy2wnob+1FmP9bdD9+gHLQZDofF2c1FqOijKWA=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "version=about['__version__']," "version='${version}',"
  '';

  nativeBuildInputs = [
    setuptools
  ];

  dontWrapPythonPrograms = true;

  # Projec thas no released tests
  doCheck = false;

  pythonImportsCheck = [
    "exrex"
  ];

  meta = with lib; {
    description = "Irregular methods on regular expressions";
    homepage = "https://github.com/asciimoo/exrex";
    license = with licenses; [ agpl3Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
