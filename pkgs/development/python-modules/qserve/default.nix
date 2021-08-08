{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
}:

buildPythonPackage rec {
  pname = "qserve";
  version = "0.3.0";
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "dac1ee4ec60af6beb9af8f3f02d08d6db4cc9868b0915d626cb900a50d003ed4";
  };

  meta = with lib; {
    description = "Job queue server";
    homepage = "https://github.com/pediapress/qserve";
    license = licenses.bsd3;
  };

}
