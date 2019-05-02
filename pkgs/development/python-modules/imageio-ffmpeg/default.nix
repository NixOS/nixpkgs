{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
}:

buildPythonPackage rec {
  pname = "imageio-ffmpeg";
  version = "0.3.0";

  src = fetchPypi {
    sha256 = "1hnn00xz9jyksnx1g0r1icv6ynbdnxq4cfnmb58ikg6ymi20al18";
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
