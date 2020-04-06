{ stdenv, buildPythonPackage, fetchPypi
, six, click, requests, pytz, tabulate, pythonOlder
}:

buildPythonPackage rec {
  pname = "alerta";
  version = "7.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2c8d9cf174d7f66401a5deb104b96375f3877b6c768568705f700faf3adbf448";
  };

  propagatedBuildInputs = [ six click requests pytz tabulate ];

  doCheck = false;

  postInstall = ''
    wrapProgram $out/bin/alerta --prefix PYTHONPATH : "$PYTHONPATH"
  '';

  disabled = pythonOlder "3.5";

  meta = with stdenv.lib; {
    homepage = https://alerta.io;
    description = "Alerta Monitoring System command-line interface";
    license = licenses.asl20;
  };
}
