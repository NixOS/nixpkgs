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

  makeFlags = [
    "AR=${stdenv.cc.targetPrefix}ar"
  ];

  nativeBuildInputs = [ autoreconfHook ];

  # fails 1 out of 1 tests with "BAD GLOBAL SYMBOLS" on i686
  # which can also be fixed with
  # hardeningDisable = lib.optional stdenv.isi686 "pic";
  # but it's better to disable tests than loose ASLR on i686
  doCheck = !stdenv.isi686;

  meta = with lib; {
    description = "ATSC A/52 stream decoder";
    homepage = "https://code.videolan.org/videolan/liba52";
    platforms = platforms.unix;
    license = licenses.gpl2Plus;
  };
}
