{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytest,
}:

buildPythonPackage rec {
  pname = "ansicolors";
  version = "1.1.8";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    hash = "sha256-mflPXjNIoLzUPILl/EQUATzMGdcL2TmtceATPOnDcuA=";
  };

  nativeCheckInputs = [ pytest ];

  checkPhase = ''
    py.test
  '';

  meta = with lib; {
    homepage = "https://github.com/verigak/colors/";
    description = "ANSI colors for Python";
    license = licenses.isc;
    maintainers = with maintainers; [ copumpkin ];
  };
}
