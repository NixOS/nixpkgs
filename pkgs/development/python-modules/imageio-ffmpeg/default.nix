{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
}:

buildPythonPackage rec {
  pname = "imageio-ffmpeg";
  version = "0.4.2";

  src = fetchPypi {
    sha256 = "13b05b17a941a9f4a90b16910b1ffac159448cff051a153da8ba4b4343ffa195";
    inherit pname version;
  };

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
