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
  version = "0.30.4.post1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-jQLVD3IsekQfO0P80miKOtyTyGldc2Vn/mJFfvvgMFo=";
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

  # Ensure that there is enough space for the `fixDarwinDylibNames` hook to
  # update the install names of the output dylibs.
  env.NIX_LDFLAGS = lib.optionalString stdenv.hostPlatform.isDarwin "-headerpad_max_install_names";

  pythonImportsCheck = [ "klayout" ];

  meta = {
    description = "KLayout’s Python API";
    homepage = "https://github.com/KLayout/klayout";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ fbeffa ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
