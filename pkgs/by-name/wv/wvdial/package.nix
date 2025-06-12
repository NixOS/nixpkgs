{
  stdenv,
  fetchFromGitea,
  fetchpatch,
  wvstreams,
  pkg-config,
  lib,
}:

stdenv.mkDerivation {
  pname = "wvdial";
  version = "unstable-2016-06-15";

  src = fetchFromGitea {
    domain = "gitea.osmocom.org";
    owner = "retronetworking";
    repo = "wvdial";
    rev = "42d084173cc939586c1963b8835cb00ec56b2823";
    hash = "sha256-q7pFvpJvv+ZvbN4xxolI9ZRULr+N5sqO9BOXUqSG5v4=";
  };

  patches = [
    (fetchpatch {
      url = "https://git.openembedded.org/meta-openembedded/plain/meta-oe/recipes-connectivity/wvdial/wvdial/typo_pon.wvdial.1.patch?h=73a68490efe05cdbec540ec6f17782816632a24d";
      hash = "sha256-fsneoB5GeKH/nxwW0z8Mk6892PtnZ3J77wP4BGo3Tj8=";
    })
  ];

  buildInputs = [ wvstreams ];
  nativeBuildInputs = [ pkg-config ];

  makeFlags = [
    "prefix=${placeholder "out"}"
    "PPPDIR=${placeholder "out"}/etc/ppp/peers"
  ];

  meta = {
    description = "Dialer that automatically recognises the modem";
    homepage = "https://gitea.osmocom.org/retronetworking/wvdial";
    license = lib.licenses.lgpl2;
    maintainers = with lib.maintainers; [ flokli ];
    platforms = lib.platforms.linux;
  };
}
