{ lib, buildPythonPackage, isPy3k, olm
, cffi, future, typing }:

buildPythonPackage {
  pname = "python-olm";
  inherit (olm) src version;

  disabled = !isPy3k;

  sourceRoot = "source/python";
  buildInputs = [ olm ];

  preBuild = ''
    make include/olm/olm.h
  '';

  propagatedBuildInputs = [
    cffi
    future
    typing
  ];

  propagatedNativeBuildInputs = [
    cffi
  ];

  # Some required libraries for testing are not packaged yet.
  doCheck = false;
  pythonImportsCheck = [ "olm" ];

  meta = {
    inherit (olm.meta) license maintainers;
    description = "Python bindings for Olm";
    homepage = "https://gitlab.matrix.org/matrix-org/olm/tree/master/python";
  };
}
