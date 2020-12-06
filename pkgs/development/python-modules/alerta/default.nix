{ stdenv, buildPythonPackage, fetchPypi
, six, click, requests, requests-hawk, pytz, tabulate, pythonOlder
}:

buildPythonPackage rec {
  pname = "alerta";
  version = "8.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a689b2551655ffeb1fa0af2b652653c9355e4f612a3cb8265fcb53c47f83f7c0";
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
