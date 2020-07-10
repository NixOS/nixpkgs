{ lib
, buildPythonPackage
, fetchPypi
, flit
, isPy3k
, pytoml
}:

buildPythonPackage rec {
  pname = "flit-core";
  version = "2.3.0";
  disabled = !isPy3k;

  format = "pyproject";

  src = fetchPypi {
    inherit version;
    pname = "flit_core";
    sha256 = "a50bcd8bf5785e3a7d95434244f30ba693e794c5204ac1ee908fc07c4acdbf80";
  };

  propagatedBuildInputs = [
    pytoml
  ];

  passthru.tests = {
    inherit flit;
  };

  meta = {
    description = "Distribution-building parts of Flit. See flit package for more information";
    homepage = "https://github.com/takluyver/flit";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.fridh ];
  };
}
