{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  numpy,
  pytestCheckHook,
  pytest-cov-stub,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyevtk";
  version = "1.7.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;

    hash = "sha256-Ia07GQWwa/KIFmYp8AAtE6nGZOtCvL7WJNIDLXuLz1I=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail 'setup_requires=["pytest-runner"],' 'setup_requires=[],'
  '';

  build-system = [ setuptools ];
  dependencies = [ numpy ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
  ];

  pythonImportsCheck = [ "pyevtk" ];

  meta = {
    description = "Exports data to binary VTK files for visualization/analysis";
    homepage = "https://github.com/pyscience-projects/pyevtk";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
})
