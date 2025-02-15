{
  lib,
  buildPythonPackage,
  fetchPypi,
  fetchpatch,
}:

buildPythonPackage rec {
  pname = "kconfiglib";
  version = "14.1.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0g690bk789hsry34y4ahvly5c8w8imca90ss4njfqf7m2qicrlmy";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/ulfalizer/Kconfiglib/pull/119/commits/3161fec0b9ff9154dbd952c3481400118fabb744.patch";
      sha256 = "sha256-prpun9JdHEi8l7Q4IFqz953/uFR3xbXOVfHNOwOyGcE=";
    })
  ];

  # doesnt work out of the box but might be possible
  doCheck = false;

  meta = with lib; {
    description = "Flexible Python 2/3 Kconfig implementation and library";
    homepage = "https://github.com/ulfalizer/Kconfiglib";
    license = licenses.isc;
    maintainers = with maintainers; [ teto ];
  };
}
