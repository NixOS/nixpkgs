{ lib
, buildPythonPackage
, fetchPypi
, fetchpatch
, isPy3k
}:

buildPythonPackage rec {
  pname = "imageio-ffmpeg";
  version = "0.4.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "13b05b17a941a9f4a90b16910b1ffac159448cff051a153da8ba4b4343ffa195";
  };
  patches = [ (fetchpatch {
    # Fixes compatibility with python3.9
    # Should be included in the next release after 0.4.2
    url = "https://github.com/imageio/imageio-ffmpeg/pull/43/commits/b90c39fe3d29418d67d953588ed9fdf4d848f811.patch";
    sha256 = "0d9kf4w6ldwag3s2dr9zjin6wrj66fnl4fn8379ci4q4qfsqgx3f";
  })];

  disabled = !isPy3k;

  # No test infrastructure in repository.
  doCheck = false;

  meta = with lib; {
    description = "FFMPEG wrapper for Python";
    homepage = "https://github.com/imageio/imageio-ffmpeg";
    license = licenses.bsd2;
    maintainers = [ maintainers.pmiddend ];
  };

}
