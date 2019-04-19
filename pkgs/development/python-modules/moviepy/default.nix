{ stdenv
, buildPythonPackage
, fetchPypi
, pythonAtLeast
, numpy
, decorator
, imageio
, imageio-ffmpeg
, isPy3k
, proglog
, requests
, tqdm
}:

buildPythonPackage rec {
  pname = "moviepy";
  version = "1.0.0";

  disabled = !(pythonAtLeast "3.4");

  src = fetchPypi {
    inherit pname version;
    sha256 = "16c7ffca23d90c76dd7b163f648c8166dfd589b7c180b8ff75aa327ae0a2fc6d";
  };

  # No tests
  doCheck = false;
  propagatedBuildInputs = [ numpy decorator imageio imageio-ffmpeg tqdm requests proglog ];

  meta = with stdenv.lib; {
    description = "Video editing with Python";
    homepage = http://zulko.github.io/moviepy/;
    license = licenses.mit;
  };

}
