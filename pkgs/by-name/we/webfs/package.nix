{
  lib,
  stdenv,
  fetchFromGitHub,
  mailcap,
  openssl,
}:

stdenv.mkDerivation {
  pname = "webfs";
  version = "1.21-unstable-2021-02-24";

  src = fetchFromGitHub {
    owner = "ourway";
    repo = "webfsd";
    rev = "228affae0774251c6925372d465eb4e648327879";
    hash = "sha256-uTo9f66cOKSsIGLUj1E/ywMXT1peekb93UlFBrfkpN0=";
  };

  buildInputs = [ openssl ];

  makeFlags = [
    "mimefile=${placeholder "out"}/etc/mime.types"
    "prefix=${placeholder "out"}"
    "USE_THREADS=yes"
  ];

  postInstall = ''
    install -Dm444 -t $out/etc ${mailcap}/etc/mime.types
  '';

  meta = with lib; {
    description = "HTTP server for purely static content";
    homepage = "http://linux.bytesex.org/misc/webfs.html";
    license = licenses.gpl2Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ zimbatm ];
    mainProgram = "webfsd";
  };
}
