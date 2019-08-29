{ stdenv, buildPythonPackage, fetchPypi
, six, click, requests, pytz, tabulate, pythonOlder
}:

buildPythonPackage rec {
  pname = "alerta";
  version = "6.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f9f0f8f800798fae83c05dd52dc2f06bd77fb318c784c4b44e3acfba81338881";
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
