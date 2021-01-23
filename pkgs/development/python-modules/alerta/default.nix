{ lib, stdenv, buildPythonPackage, fetchPypi
, six, click, requests, requests-hawk, pytz, tabulate, pythonOlder
}:

buildPythonPackage rec {
  pname = "alerta";
  version = "8.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "83c7d751bad0cb9bd7886700da4cd83c5451b2e8eb8d4cc697966e02d6a565f8";
  };

  propagatedBuildInputs = [ six click requests requests-hawk pytz tabulate ];

  doCheck = false;

  postInstall = ''
    wrapProgram $out/bin/alerta --prefix PYTHONPATH : "$PYTHONPATH"
  '';

  disabled = pythonOlder "3.5";

  meta = with lib; {
    homepage = "https://alerta.io";
    description = "Alerta Monitoring System command-line interface";
    license = licenses.asl20;
  };
}
