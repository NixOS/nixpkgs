{ stdenv, buildPythonPackage, fetchPypi }:
buildPythonPackage rec {
  pname = "htmlmin";
  version = "0.1.11";
  name = "${pname}-${version}";
  src = fetchPypi {
    inherit pname version;
    sha256 = "f27fb96fdddeb1725ee077be532c7bea23288c69d0e996e7798f24fae7a14e5e";
  };

  # Tests run fine in a normal source checkout, but not when being built by nix.
  doCheck = false;

  meta = {
    description = "A configurable HTML Minifier with safety features";
    homepage = https://pypi.python.org/pypi/htmlmin;
    license = stdenv.lib.licenses.bsd3;
    maintainers = [stdenv.lib.maintainers.ahmedtd];
  };
}
