{
  lib,
  buildPythonPackage,
  fetchPypi,
  curl,
  cython,
  expat,
  libpng,
  setuptools,
  stdenv,
  fixDarwinDylibNames,
}:

buildPythonPackage rec {
  pname = "klayout";
  version = "0.30.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-HRuRnwKyTVecjAY0BzUuOahrdMMUlXLUiAoProNjS6U=";
  };

  build-system = [
    cython
    setuptools
  ];

  buildInputs = [
    curl
    expat
    libpng
  ];

  # libpng-config is needed for the build on Darwin
  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    libpng.dev
    fixDarwinDylibNames
  ];

  pythonImportsCheck = [ "klayout" ];

  meta = with lib; {
    description = "KLayout’s Python API";
    homepage = "https://github.com/KLayout/klayout";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ fbeffa ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
