{ stdenv, buildPythonPackage, fetchPypi
, six, click, requests, pytz, tabulate, pythonOlder
}:

buildPythonPackage rec {
  pname = "alerta";
  version = "7.4.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "926f1101a1b57a9fad611f1e1d5af751693efcc344a9db01af50e2fe0d362d84";
  };

  propagatedBuildInputs = [ six click requests pytz tabulate ];

  doCheck = false;

  postInstall = ''
    wrapProgram $out/bin/alerta --prefix PYTHONPATH : "$PYTHONPATH"
  '';

  disabled = pythonOlder "3.5";

  meta = with stdenv.lib; {
    homepage = "https://alerta.io";
    description = "Alerta Monitoring System command-line interface";
    license = licenses.asl20;
  };
}
