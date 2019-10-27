{ lib
, buildPythonPackage
, fetchPypi
, setuptools_scm
, six
, pytest }:

buildPythonPackage rec {
  version = "0.1.4";
  pname = "pyvcd";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0dv9wac5y5z9j54ypyc59csxdiy9ybpphw9ipxp1k8nfg65q9jxx";
  };

  buildInputs = [ setuptools_scm ];
  propagatedBuildInputs = [ six ];

  checkPhase = ''
    py.test
  '';

  checkInputs = [ pytest ];

  meta = with lib; {
    description = "Python package for writing Value Change Dump (VCD) files";
    homepage = https://github.com/SanDisk-Open-Source/pyvcd;
    license = licenses.mit;
    maintainers = [ maintainers.sb0 ];
  };
}
