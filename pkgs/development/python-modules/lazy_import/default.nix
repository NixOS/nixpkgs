{ lib, buildPythonPackage, fetchPypi
, pytest
, pytest-xdist
, six }:

buildPythonPackage rec {
  pname = "lazy_import";
  version = "0.2.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0gca9xj60qr3aprj9qdc66crr4r7hl8wzv6gc9y40nclazwawj91";
  };

  nativeCheckInputs = [
    pytest
    pytest-xdist
  ];

  propagatedBuildInputs = [
    six
  ];

  checkPhase = ''
    cd lazy_import
    pytest --boxed
  '';

  meta = with lib; {
    description = "lazy_import provides a set of functions that load modules, and related attributes, in a lazy fashion.";
    homepage = "https://github.com/mnmelo/lazy_import";
    license = licenses.gpl3;
    maintainers = [ maintainers.marenz ];
  };
}
