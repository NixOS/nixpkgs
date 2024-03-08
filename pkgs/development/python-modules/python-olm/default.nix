{ lib, buildPythonPackage, isPy3k, olm
, cffi
, future
, aspectlib
, pytest-benchmark
, pytestCheckHook
}:

buildPythonPackage {
  pname = "python-olm";
  format = "setuptools";
  inherit (olm) src version;

  disabled = !isPy3k;

  sourceRoot = "${olm.src.name}/python";
  buildInputs = [ olm ];

  preBuild = ''
    make include/olm/olm.h
  '';

  propagatedBuildInputs = [
    cffi
    future
  ];

  propagatedNativeBuildInputs = [
    cffi
  ];

  pythonImportsCheck = [ "olm" ];

  nativeCheckInputs = [
    aspectlib
    pytest-benchmark
    pytestCheckHook
  ];

  meta = {
    inherit (olm.meta) license maintainers;
    description = "Python bindings for Olm";
    homepage = "https://gitlab.matrix.org/matrix-org/olm/tree/master/python";
  };
}
