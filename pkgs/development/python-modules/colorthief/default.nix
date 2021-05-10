{ lib, buildPythonPackage, fetchPypi, pillow }:

buildPythonPackage rec {
  pname = "colorthief";
  version = "0.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "08bjsmmkihyksms2vgndslln02rvw56lkxz28d39qrnxbg4v1707";
  };

  propagatedBuildInputs = [ pillow ];

  # No tests
  doCheck = false;
  pythonImportsCheck = [ "colorthief" ];

  meta = with lib; {
    description = "Module for grabbing the color palette from an image";
    homepage = "https://github.com/fengsp/color-thief-py";
    license = licenses.bsd3;
    maintainers = with maintainers; [ mnacamura ];
    platforms = platforms.unix;
  };
}
