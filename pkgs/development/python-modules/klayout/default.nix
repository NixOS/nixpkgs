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
  version = "0.30.5";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-V55O7Ndjw3YOhe8OKsHcwFh4QT52ScrP5164wNP44gc=";
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

  meta = {
    description = "KLayout’s Python API";
    homepage = "https://github.com/KLayout/klayout";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ fbeffa ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
