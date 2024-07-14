{
  lib,
  buildPythonPackage,
  fetchPypi,
  fonttools,
  fs,
  pyclipper,
  defcon,
  fontpens,
  setuptools-scm,
  pytest,
}:

buildPythonPackage rec {
  pname = "booleanoperations";
  version = "0.9.0";

  src = fetchPypi {
    pname = "booleanOperations";
    inherit version;
    hash = "sha256-jPqCHDKtN0+hINay4LRE6+rFfJHmYxUoZF+hmsKigbg=";
    extension = "zip";
  };

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [
    fonttools
    fs
    pyclipper
    defcon
    fontpens
  ];

  nativeCheckInputs = [ pytest ];

  meta = with lib; {
    description = "Boolean operations on paths";
    homepage = "https://github.com/typemytype/booleanOperations";
    license = licenses.mit;
    maintainers = [ maintainers.sternenseemann ];
  };
}
