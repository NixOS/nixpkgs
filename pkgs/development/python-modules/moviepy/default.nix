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
  version = "1.0.1";

  disabled = !(pythonAtLeast "3.4");

  src = fetchPypi {
    inherit pname version;
    sha256 = "1vgi9k1r4f5s9hzfzlhmmc574n80aq713ahv8cnbj3jci070lnwx";
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
    homepage = http://zulko.github.io/moviepy/;
    license = licenses.mit;
  };

}
