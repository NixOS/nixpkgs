{ lib, buildPythonPackage, fetchPypi
, six, click, requests, requests-hawk, pytz, tabulate, pythonOlder
}:

buildPythonPackage rec {
  pname = "alerta";
  version = "8.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "260ff3118e73396104129928217b0f317ac5afdff8221874d8986df22ecf5f34";
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
