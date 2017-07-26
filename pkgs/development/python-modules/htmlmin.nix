{ stdenv, buildPythonPackage, fetchPypi }:
buildPythonPackage rec {
  pname = "htmlmin";
  version = "0.1.10";
  name = "${pname}-${version}";
  src = fetchPypi {
    inherit pname version;
    sha256 = "ca5c5dfbb0fa58562e5cbc8dc026047f6cb431d4333504b11853853be448aa63";
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
