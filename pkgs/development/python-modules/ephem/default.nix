{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytest,
}:

buildPythonPackage rec {
  pname = "ephem";
  version = "4.2.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-kgyzA2nHn94QiMIGDVVepfilD9yAqSZYMv1b8ZXPFH8=";
  };

  nativeCheckInputs = [
    pytest
  ];

  # JPLTest uses assets not distributed in package
  checkPhase = ''
    pytest --pyargs ephem.tests -k "not JPLTest"
  '';

  pythonImportsCheck = [ "ephem" ];

  meta = {
    description = "Compute positions of the planets and stars";
    homepage = "https://github.com/brandon-rhodes/pyephem";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ chrisrosset ];
  };
}
