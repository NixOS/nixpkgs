{
  lib,
  buildPythonPackage,
  fetchPypi,
  regex,
}:

buildPythonPackage rec {
  pname = "re_assert";
  version = "1.1.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-UXLfvSBHoV3/I0dzXep+SVR5zH5YhBGZpKSXMlayBGQ=";
  };

  # No tests in archive
  doCheck = false;

  propagatedBuildInputs = [ regex ];

  meta = {
    description = "Show where your regex match assertion failed";
    license = lib.licenses.mit;
    homepage = "https://github.com/asottile/re-assert";
  };
}
