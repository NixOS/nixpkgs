{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytest,
}:

buildPythonPackage rec {
  pname = "py2bit";
  version = "0.3.0";
  format = "setuptools";

  checkInput = [ pytest ];

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-RQVVxAy6ZpV6yMmktq+2Jfs0xLtBY43njIdmH/i2gu8=";
  };

  meta = with lib; {
    homepage = "https://github.com/deeptools/py2bit";
    description = "File access to 2bit files";
    longDescription = ''
      A python extension, written in C, for quick access to 2bit files. The extension uses lib2bit for file access.
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ scalavision ];
  };
}
