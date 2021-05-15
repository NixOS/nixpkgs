{ lib, stdenv, buildPythonPackage, fetchFromGitHub, scipy, ffmpeg-full }:

buildPythonPackage rec {
  pname = "pydub";
  version = "0.25.1";
  # pypi version doesn't include required data files for tests
  src = fetchFromGitHub {
    owner = "jiaaro";
    repo = pname;
    rev = "v${version}";
    sha256 = "0xskllq66wqndjfmvp58k26cv3w480sqsil6ifwp4gghir7hqc8m";
  };


  # disable a test that fails on aarch64 due to rounding errors
  postPatch = lib.optionalString stdenv.isAarch64 ''
    substituteInPlace test/test.py \
      --replace "test_overlay_with_gain_change" "notest_overlay_with_gain_change"
  '';

  checkInputs = [ scipy ffmpeg-full ];

  checkPhase = ''
    python test/test.py
  '';

  meta = with lib; {
    description = "Manipulate audio with a simple and easy high level interface.";
    homepage    = "http://pydub.com/";
    license     = licenses.mit;
    platforms   = platforms.all;
  };
}
