{ stdenv, buildPythonPackage, fetchPypi
, six, click, requests, pytz, tabulate, pythonOlder
}:

buildPythonPackage rec {
  pname = "alerta";
  version = "7.5.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "849966c05e9899ac72af23991e9f17271c42bba89035c49d257a9dd96b54695b";
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
