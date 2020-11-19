{ stdenv, buildPythonPackage, fetchFromGitHub, scipy, ffmpeg-full }:

buildPythonPackage rec {
  pname = "pydub";
  version = "0.24.1";
  # pypi version doesn't include required data files for tests
  src = fetchFromGitHub {
    owner = "jiaaro";
    repo = pname;
    rev = "v${version}";
    sha256 = "1pv4n54kkjpbjlvwh9b6a7zyq1ylg0fjmd2q4ws9nc2a6mrcivhc";
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
