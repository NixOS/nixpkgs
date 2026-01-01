{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytest,
}:

buildPythonPackage rec {
  pname = "ephem";
  version = "4.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-PE/WT0U+j0DPhiQgpw2pWnG2SHrOdejgz4XXNwfbYGU=";
  };

  nativeCheckInputs = [
    pytest
  ];

  # JPLTest uses assets not distributed in package
  checkPhase = ''
    pytest --pyargs ephem.tests -k "not JPLTest"
  '';

  pythonImportsCheck = [ "ephem" ];

<<<<<<< HEAD
  meta = {
    description = "Compute positions of the planets and stars";
    homepage = "https://github.com/brandon-rhodes/pyephem";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ chrisrosset ];
=======
  meta = with lib; {
    description = "Compute positions of the planets and stars";
    homepage = "https://github.com/brandon-rhodes/pyephem";
    license = licenses.mit;
    maintainers = with maintainers; [ chrisrosset ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
