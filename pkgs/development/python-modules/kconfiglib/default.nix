{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "kconfiglib";
  version = "14.1.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0g690bk789hsry34y4ahvly5c8w8imca90ss4njfqf7m2qicrlmy";
  };

  # doesnt work out of the box but might be possible
  doCheck = false;

  meta = with lib; {
    description = "Flexible Python 2/3 Kconfig implementation and library";
    homepage = "https://github.com/ulfalizer/Kconfiglib";
    license = licenses.isc;
    maintainers = with maintainers; [ teto ];
  };
}
