{
  lib,
  buildPythonPackage,
  fetchPypi,
  python,
}:

buildPythonPackage rec {
  pname = "pynzb";
  version = "0.1.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-BzWziJoRdLu2VBjuUDYp0/Xkpj8EsW9G/7oYJT7D7xc=";
  };

  checkPhase = ''
    ${python.interpreter} -m unittest -s pynzb -t .
  '';

  # Can't get them working
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/ericflo/pynzb";
    description = "Unified API for parsing NZB files";
    license = licenses.bsd3;
    maintainers = with maintainers; [ domenkozar ];
  };
}
