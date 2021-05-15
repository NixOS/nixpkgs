{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
}:

buildPythonPackage rec {
  version = "0.13.2";
  pname = "mwlib.ext";
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "9229193ee719568d482192d9d913b3c4bb96af7c589d6c31ed4a62caf5054278";
  };

  meta = with lib; {
    description = "Dependencies for mwlib markup";
    homepage = "http://pediapress.com/code/";
    license = licenses.bsd3;
  };

}
