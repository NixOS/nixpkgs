{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  version = "1.19.0"; # note: `conan` package may require a hardcoded one
  format = "setuptools";
  pname = "patch-ng";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-J0hHkvSsHBX+Lz5M7PdLuYM9M7dccVtx0Zn34efR94Y=";
  };

  meta = with lib; {
    description = "Library to parse and apply unified diffs";
    homepage = "https://github.com/conan-io/python-patch";
    license = licenses.mit;
    maintainers = with maintainers; [ HaoZeke ];
  };
}
