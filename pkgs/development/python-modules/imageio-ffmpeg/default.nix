{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
}:

buildPythonPackage rec {
  pname = "imageio-ffmpeg";
  version = "0.2.0";

  src = fetchPypi {
    sha256 = "191k77hd69lfmd8p4w02c2ajjdsall6zijn01gyhqi11n48wpsib";
    inherit pname version;
  };

  disabled = !isPy3k;

  # No test infrastructure in repository.
  doCheck = false;

  meta = with lib; {
    description = "FFMPEG wrapper for Python";
    homepage = https://github.com/imageio/imageio-ffmpeg;
    license = licenses.bsd2;
    maintainers = [ maintainers.pmiddend ];
  };

}
