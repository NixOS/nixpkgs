{ stdenv, buildPythonPackage, fetchPypi
, six, click, requests, requests-hawk, pytz, tabulate, pythonOlder
}:

buildPythonPackage rec {
  pname = "alerta";
  version = "8.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "49e0862c756d644e9349f5040dd59d135cd871ffeaea5fc288eb3a2e818cf61a";
  };

  propagatedBuildInputs = [ six click requests requests-hawk pytz tabulate ];

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
