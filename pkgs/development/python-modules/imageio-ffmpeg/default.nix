{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchurl
, isPy3k
, numpy
, ffmpeg
, pytest
, psutil
}:

buildPythonPackage rec {
  pname = "imageio-ffmpeg";
  version = "0.4.1";

  # pypi does not contain tests, using github sources instead
  src = fetchFromGitHub {
    owner = "imageio";
    repo = pname;
    rev = "v${version}";
    sha256 = "0yv47kn0ng58638dkl75ih6dfba6bsl5kh49n7m8pg35063pwcbx";
  };

  test_url1 = fetchurl {
    url = "https://raw.githubusercontent.com/imageio/imageio-binaries/master/images/cockatoo.mp4";
    sha256 = "19cayf0dxw7xmqzjf7q2sdh4ajxni8c2ip6j2vi8djl8lbskbpjz";
  };

  test_url2 = fetchurl {
    url = "https://raw.githubusercontent.com/imageio/imageio-binaries/master/images/realshort.mp4";
    sha256 = "067ygc924iv8d5bm9w1y9317n0mcd2px8ahpl6g3ni9h44n5rcx8";
  };

  buildInputs = [
    ffmpeg
  ];

  disabled = !isPy3k;

  patchPhase = ''
    substituteInPlace imageio_ffmpeg/_utils.py  --replace \
      'os.getenv("IMAGEIO_FFMPEG_EXE", None)' \
      '"${ffmpeg}/bin/ffmpeg"'
    substituteInPlace tests/testutils.py  --replace \
      'os.path.join(test_dir, "cockatoo.mp4")' \
      '"${test_url1}"'
    substituteInPlace tests/testutils.py  --replace \
      'os.path.join(test_dir, "realshort.mp4")' \
      '"${test_url1}"'
    substituteInPlace tests/testutils.py  --replace \
      'os.path.join(test_dir, "test.mp4")' \
      '"test.mp4"'
    substituteInPlace tests/testutils.py  --replace \
      'have_downloaded = False' \
      'have_downloaded = True'
  '';

  checkPhase = ''
    for f in tests/test*.py; do echo ========== $f ==========; python $f; done
  '';

  checkInputs = [
    numpy
    pytest
    psutil
  ];

  meta = with lib; {
    description = "FFMPEG wrapper for Python";
    homepage = "https://github.com/imageio/imageio-ffmpeg";
    license = licenses.bsd2;
    maintainers = [ maintainers.pmiddend ];
  };

}
