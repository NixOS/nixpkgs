{
  lib,
  buildPythonPackage,
  fetchPypi,
  curl,
  cython,
  expat,
  libpng,
  setuptools,
}:

buildPythonPackage rec {
  pname = "klayout";
  version = "0.29.12";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-6eJpoxdrUuMBn78QTqvh8zfUH0B8YvWTQR28hZ7HLCY=";
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

  pythonImportsCheck = [ "klayout" ];

  meta = with lib; {
    description = "KLayout’s Python API";
    homepage = "https://github.com/KLayout/klayout";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ fbeffa ];
    platforms = platforms.linux;
  };
}
