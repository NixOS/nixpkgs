{ stdenv, buildPythonPackage, fetchPypi, makeWrapper
, six, click, requests, pytz, tabulate
}:

buildPythonPackage rec {
  pname = "alerta";
  version = "6.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "08l366g0arpd23bm7bzk0hpmfd3z6brb8p24rjwkb3gvafhk7cz9";
  };

  buildInputs = [ six click requests pytz tabulate ];

  doCheck = false;

  postInstall = ''
    wrapProgram $out/bin/alerta --prefix PYTHONPATH : "$PYTHONPATH"
  '';

  meta = with stdenv.lib; {
    homepage = https://alerta.io;
    description = "Alerta Monitoring System command-line interface";
    license = licenses.asl20;
  };
}
