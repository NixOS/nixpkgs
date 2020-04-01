{ stdenv, buildPythonPackage, fetchPypi, mailman, mock }:

buildPythonPackage rec {
  pname = "mailman-hyperkitty";
  version = "1.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1lfqa9admhvdv71f528jmz2wl0i5cv77v6l64px2pm4zqr9ckkjx";
  };

  propagatedBuildInputs = [ mailman ];
  checkInputs = [ mock ];

  checkPhase = ''
    python -m nose2 -v
  '';
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Mailman archiver plugin for HyperKitty";
    homepage = "https://gitlab.com/mailman/mailman-hyperkitty";
    license = licenses.gpl3;
    maintainers = with maintainers; [ globin peti ];
  };
}
