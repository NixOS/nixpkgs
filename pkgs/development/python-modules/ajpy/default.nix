{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "ajpy";
  version = "0.0.5";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "173wm207zyi86m2ms7vscakdi4mmjqfxqsdx1gn0j9nn0gsf241h";
  };

  # ajpy doesn't have tests
  doCheck = false;

  meta = {
    description = "AJP package crafting library";
    homepage = "https://github.com/hypn0s/AJPy/";
    license = lib.licenses.lgpl2;
    maintainers = with lib.maintainers; [ y0no ];
  };
}
