{ stdenv, buildPythonPackage, fetchPypi, pythonOlder, isPy3k
, pytest
, pytest_xdist
, six }:

buildPythonPackage rec {
  pname = "lazy_import";
  version = "0.2.2";

  disabled = pythonOlder "2.7" || (isPy3k && pythonOlder "3.4");

  src = fetchPypi {
    inherit pname version;
    sha256 = "0gca9xj60qr3aprj9qdc66crr4r7hl8wzv6gc9y40nclazwawj91";
  };

  checkInputs = [
    pytest
    pytest_xdist
  ];

  propagatedBuildInputs = [
    six
  ];

  meta = with stdenv.lib; {
    description = "lazy_import provides a set of functions that load modules, and related attributes, in a lazy fashion.";
    homepage = https://github.com/mnmelo/lazy_import;
    license = licenses.gpl3;
    maintainers = [ maintainers.marenz ];
  };
}
