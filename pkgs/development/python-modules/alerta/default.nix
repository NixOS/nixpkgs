{ stdenv, buildPythonPackage, fetchPypi
, six, click, requests, pytz, tabulate, pythonOlder
}:

buildPythonPackage rec {
  pname = "alerta";
  version = "7.5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e903d4b097d4650983faecedc4e2dffd27a962b671643098f8425f9a19884d0f";
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
