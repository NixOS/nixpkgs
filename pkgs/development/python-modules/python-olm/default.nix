{
  buildPythonPackage,
  isPy3k,
  olm,
  setuptools,
  cffi,
  aspectlib,
  pytest-benchmark,
  pytestCheckHook,
}:

buildPythonPackage {
  pname = "python-olm";
  inherit (olm) src version;
  pyproject = true;

  disabled = !isPy3k;

  sourceRoot = "${olm.src.name}/python";
  buildInputs = [ olm ];

  preBuild = ''
    make include/olm/olm.h
  '';

  build-system = [
    setuptools
  ];

  dependencies = [
    cffi
  ];

  propagatedNativeBuildInputs = [ cffi ];

  pythonImportsCheck = [ "olm" ];

  nativeCheckInputs = [
    aspectlib
    pytest-benchmark
    pytestCheckHook
  ];

  pytestFlags = [ "--benchmark-disable" ];

  meta = {
    inherit (olm.meta) license maintainers;
    description = "Python bindings for Olm";
    homepage = "https://gitlab.matrix.org/matrix-org/olm/tree/master/python";
  };
}
