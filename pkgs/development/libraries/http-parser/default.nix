{ lib, stdenv, fetchFromGitHub, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "http-parser";
  version = "2.9.4";

  src = fetchFromGitHub {
    owner = "nodejs";
    repo = "http-parser";
    rev = "v${version}";
    sha256 = "1vda4dp75pjf5fcph73sy0ifm3xrssrmf927qd1x8g3q46z0cv6c";
  };

  env.NIX_CFLAGS_COMPILE = "-Wno-error";
  patches = [
    ./build-shared.patch
  ] ++ lib.optionals stdenv.isAarch32 [
    # https://github.com/nodejs/http-parser/pull/510
    (fetchpatch {
      url = "https://github.com/nodejs/http-parser/commit/4f15b7d510dc7c6361a26a7c6d2f7c3a17f8d878.patch";
      sha256 = "sha256-rZZMJeow3V1fTnjadRaRa+xTq3pdhZn/eJ4xjxEDoU4=";
    })
  ];
  makeFlags = [ "DESTDIR=" "PREFIX=$(out)" ];
  buildFlags = [ "library" ];
  doCheck = true;
  checkTarget = "test";

  meta = with lib; {
    description = "An HTTP message parser written in C";
    homepage = "https://github.com/nodejs/http-parser";
    maintainers = with maintainers; [ matthewbauer ];
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
