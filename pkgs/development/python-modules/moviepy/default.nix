{ stdenv
, buildPythonPackage
, fetchPypi
, pythonAtLeast
, numpy
, decorator
, imageio
, imageio-ffmpeg
, proglog
, requests
, tqdm
# Advanced image processing (triples size of output)
, advancedProcessing ? false
, opencv3 ? null
, scikitimage ? null
, scikitlearn ? null
, scipy ? null
, matplotlib ? null
, youtube-dl ? null
}:

assert advancedProcessing -> (
  opencv3 != null && scikitimage != null && scikitlearn != null
  && scipy != null && matplotlib != null && youtube-dl != null);

buildPythonPackage rec {
  pname = "moviepy";
  version = "1.0.2";

  disabled = !(pythonAtLeast "3.4");

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ajw2xmcd962qw2kxxnbp08l5vgk5k78sls9bb227lw8aa51ln80";
  };

  # No tests, require network connection
  doCheck = false;

  propagatedBuildInputs = [
    numpy decorator imageio imageio-ffmpeg tqdm requests proglog
  ] ++ (stdenv.lib.optionals advancedProcessing [
    opencv3 scikitimage scikitlearn scipy matplotlib youtube-dl
  ]);

  meta = with stdenv.lib; {
    description = "Video editing with Python";
    homepage = "https://zulko.github.io/moviepy/";
    license = licenses.mit;
  };

}
