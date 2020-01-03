{ lib
, buildPythonPackage
, fetchPypi
, setuptools_scm
, six
, pytest }:

buildPythonPackage rec {
  version = "0.1.5";
  pname = "pyvcd";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9e796f8d00d8392716bef9759f118231f5d77d2fff79d8a32151e3bb5579ff25";
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
