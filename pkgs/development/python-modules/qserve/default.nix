{ stdenv
, buildPythonPackage
, fetchPypi
, isPy3k
}:

buildPythonPackage rec {
  pname = "qserve";
  version = "0.2.8";
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "0b04b2d4d11b464ff1efd42a9ea9f8136187d59f4076f57c9ba95361d41cd7ed";
  };

  meta = with stdenv.lib; {
    description = "Job queue server";
    homepage = "https://github.com/pediapress/qserve";
    license = licenses.bsd3;
  };

}
