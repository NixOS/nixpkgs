{
  lib,
  buildPythonPackage,
  cython,
  fetchPypi,
  keyutils,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "keyutils";
  version = "0.6";
  format = "setuptools";

  # github version comes bundled with tests
  # but github version now 404s
  # use pypi instead and disable tests (tests are missing)
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-qc+6zDOlraFlUx/y1uEkHsk6nwyrxjIF1v9z+O/zN1I=";
  };

  doCheck = false;
  pythonImportsCheck = [ "keyutils" ];

  postPatch = ''
    substituteInPlace setup.py --replace '"pytest-runner"' ""
  '';

  preBuild = ''
    cython keyutils/_keyutils.pyx
  '';

  preCheck = ''
    rm -rf keyutils
  '';

  buildInputs = [ keyutils ];
  nativeBuildInputs = [ cython ];
  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Set of python bindings for keyutils";
    homepage = "https://github.com/sassoftware/python-keyutils";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
