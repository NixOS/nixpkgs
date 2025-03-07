{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  version = "1.17.4"; # note: `conan` package may require a hardcoded one
  format = "setuptools";
  pname = "patch-ng";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1kja1nn08w0k8k6j4kad48k581hh9drvjjb8x60v9j13sxdvqyk2";
  };

  meta = with lib; {
    description = "Library to parse and apply unified diffs";
    homepage = "https://github.com/conan-io/python-patch";
    license = licenses.mit;
    maintainers = with maintainers; [ HaoZeke ];
  };
}
