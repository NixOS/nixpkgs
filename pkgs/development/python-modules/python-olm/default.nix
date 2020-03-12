{ lib, buildPythonPackage, olm,
  cffi, future, isPy3k, typing }:

buildPythonPackage {
  pname = "python-olm";
  inherit (olm) src version;

  sourceRoot = "${olm.name}/python";
  buildInputs = [ olm ];

  preBuild = ''
    make include/olm/olm.h
  '';

  propagatedBuildInputs = [
    cffi
    future
  ] ++ lib.optionals (!isPy3k) [ typing ];

  doCheck = false;

  meta = with lib; {
    description = "Python bindings for Olm";
    homepage = "https://gitlab.matrix.org/matrix-org/olm/tree/master/python";
    license = olm.meta.license;
    maintainers = [ maintainers.tilpner ];
  };
}
