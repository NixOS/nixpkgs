{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "kconfiglib";
  version = "13.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0dkfprrsds64d2jbqnwdzb4why84jaj968s3ccmyqg5385nr9fwd";
  };

  # doesnt work out of the box but might be possible
  doCheck = false;

  meta = with lib; {
    description = "A flexible Python 2/3 Kconfig implementation and library";
    homepage = https://github.com/ulfalizer/Kconfiglib;
    license = licenses.isc;
    maintainers = with maintainers; [ teto ];
  };
}
