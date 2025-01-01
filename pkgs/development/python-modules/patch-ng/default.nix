{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  version = "1.18.0"; # note: `conan` package may require a hardcoded one
  format = "setuptools";
  pname = "patch-ng";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-2gZ2KNbV/Z3FpV6rN5UdRr2VZhtyGfqzZLcRNmq8xpA=";
  };

  meta = with lib; {
    description = "Library to parse and apply unified diffs";
    homepage = "https://github.com/conan-io/python-patch";
    license = licenses.mit;
    maintainers = with maintainers; [ HaoZeke ];
  };
}
