{ lib, stdenv, fetchFromGitHub, autoreconfHook, strace, which }:

stdenv.mkDerivation rec {
  pname = "libeatmydata";
  version = "105";

  src = fetchFromGitHub {
    owner = "stewartsmith";
    repo = pname;
    rev = "${pname}-${version}";
    sha256 = "0sx803h46i81h67xbpd3c7ky0nhaw4gij214nsx4lqig70223v9r";
  };

  patches = [ ./find-shell-lib.patch ];

  patchFlags = "-p0";

  postPatch = ''
    substituteInPlace eatmydata.in \
      --replace NIX_OUT_DIR $out

    patchShebangs .
  '';

  nativeBuildInputs = [
    autoreconfHook
  ] ++ lib.optionals doCheck [ strace which ];

  # while we can *build* in parallel, the tests also run in parallel which does
  # not work with v105. Later versions (unreleased) have a fix for that. The
  # problem is that on hydra we cannot use strace, so the tests don't run there.
  enableParallelBuilding = true;
  doCheck = false;

  meta = with lib; {
    description = "Small LD_PRELOAD library to disable fsync and friends";
    homepage = "https://www.flamingspork.com/projects/libeatmydata/";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
  };
}
