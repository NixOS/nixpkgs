{ lib
, stdenv
, fetchFromGitLab
, autoreconfHook
}:

stdenv.mkDerivation rec {
  pname = "liba52";
  version = "unstable-2009-12-08";

  src = fetchFromGitLab {
    domain = "code.videolan.org";
    owner = "videolan";
    repo = pname;
    rev = "ed8b14b70fc9a344e43c820fd94a542b2a5a75bb";
    sha256 = "1ynxh4s1pdqjfirdy3j0kcbbl1pfl5sdkq2w91s2npsfh74jsc8x";
  };

  patches = [
    ./no-disable-pic.patch
    ./no-always-inline.patch
  ];

  makeFlags = [
    "AR=${stdenv.cc.targetPrefix}ar"
  ];

  nativeBuildInputs = [ autoreconfHook ];

  meta = with lib; {
    description = "ATSC A/52 stream decoder";
    homepage = "https://code.videolan.org/videolan/liba52";
    platforms = platforms.unix;
    license = licenses.gpl2Plus;
  };
}
