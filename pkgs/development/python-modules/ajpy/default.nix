{ lib, buildPythonPackage, fetchPypi }:

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

  meta = with lib; {
    description = "AJP package crafting library";
    homepage = "https://github.com/hypn0s/AJPy/";
    license = licenses.lgpl2;
    maintainers = with maintainers; [ y0no ];
  };
}
