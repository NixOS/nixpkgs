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
  version = "0.30.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-JMCc/jWZ5tpN7FaoswVS5r5GHP9qXz9SA5hiKS+1P38=";
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
