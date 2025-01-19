{
  lib,
  buildPythonPackage,
  fetchPypi,
  numpy,
  cython,
}:

buildPythonPackage rec {
  pname = "pyworld";
  version = "0.3.4";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-EGxw7np9jJukiNgCLyAzcGkppA8CZCVrjofaWquYMDo=";
  };

  nativeBuildInputs = [ cython ];

  propagatedBuildInputs = [ numpy ];

  pythonImportsCheck = [ "pyworld" ];

  meta = {
    description = "PyWorld is a Python wrapper for WORLD vocoder";
    homepage = "https://github.com/JeremyCCHsu/Python-Wrapper-for-World-Vocoder";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.mic92 ];
  };
}
