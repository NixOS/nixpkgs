{
  lib,
  buildPythonPackage,
  fetchPypi,
  cython_0,
}:

buildPythonPackage rec {
  pname = "rectangle-packer";
  version = "2.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-NORQApJV9ybEqObpOaGMrVh58Nn+WIwYeP6FyHLcvkE=";
  };

  #nativeBuildInputs = with python3Packages; [ setuptools ];
  propagatedBuildInputs = [ cython_0 ];

  doCheck = false;

  pythonImportsCheck = [ "rpack" ];

  meta = with lib; {
    description = "A library for packing rectangles into a rectangle with minimum size";
    homepage = "https://github.com/Penlect/rectangle-packer/";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ annaaurora ];
  };
}
