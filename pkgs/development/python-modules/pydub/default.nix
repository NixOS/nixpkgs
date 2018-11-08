{ stdenv, buildPythonPackage, fetchFromGitHub, scipy, ffmpeg-full }:

buildPythonPackage rec {
  pname = "pydub";
  version = "0.23.0";
  # pypi version doesn't include required data files for tests
  src = fetchFromGitHub {
    owner = "jiaaro";
    repo = pname;
    rev = "v${version}";
    sha256 = "1ijp9hlxi2d0f1ah9yj9j8cz18i9ny9jwrf2irvz58bgyv29m8bn";
  };


  # disable a test that fails on aarch64 due to rounding errors
  postPatch = stdenv.lib.optionalString stdenv.isAarch64 ''
    substituteInPlace test/test.py \
      --replace "test_overlay_with_gain_change" "notest_overlay_with_gain_change"
  '';

  checkInputs = [ scipy ffmpeg-full ];

  checkPhase = ''
    python test/test.py
  '';

  meta = with stdenv.lib; {
    description = "Manipulate audio with a simple and easy high level interface.";
    homepage    = "http://pydub.com/";
    license     = licenses.mit;
    platforms   = platforms.all;
  };
}
