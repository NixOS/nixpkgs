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
    hash = "sha256-MBDh9APWJgnsC71p3B2WtZLYpmJ6H11FNSj6f4CofJw=";
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
