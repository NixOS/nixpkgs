{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  version = "1.18.1"; # note: `conan` package may require a hardcoded one
  format = "setuptools";
  pname = "patch-ng";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Uv1G7kb2yGZ2kmgsH9cTTtxlotLQhOvsHSlaYIf8ApE=";
  };

  meta = {
    description = "Library to parse and apply unified diffs";
    homepage = "https://github.com/conan-io/python-patch";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ HaoZeke ];
  };
}
