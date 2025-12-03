{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  gnutls,
  cunit,
  ncurses,
  knot-dns,
  curlWithGnuTls,
}:

stdenv.mkDerivation rec {
  pname = "ngtcp2";
  version = "1.18.0";

  src = fetchFromGitHub {
    owner = "ngtcp2";
    repo = "ngtcp2";
    rev = "v${version}";
    hash = "sha256-sywzNSyr237U1codaEHtHvz7nqYDiJwjVpr4hpLHE60=";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];
  buildInputs = [ gnutls ];

  configureFlags = [ "--with-gnutls=yes" ];
  enableParallelBuilding = true;

  doCheck = true;
  nativeCheckInputs = [ cunit ] ++ lib.optional stdenv.hostPlatform.isDarwin ncurses;

  passthru.tests = knot-dns.passthru.tests // {
    inherit curlWithGnuTls;
  };

  meta = with lib; {
    homepage = "https://github.com/ngtcp2/ngtcp2";
    description = "Effort to implement RFC9000 QUIC protocol";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [
      vcunat # for knot-dns
    ];
  };
}

/*
  Why split from ./default.nix?

  ngtcp2 libs contain helpers to plug into various crypto libs (gnutls, patched openssl, ...).
  Building multiple of them while keeping closures separable would be relatively complicated.
  Separating the builds is easier for now; the missed opportunity to share the 0.3--0.4 MB
  library isn't such a big deal.

  Moreover upstream still commonly does incompatible changes, so agreeing
  on a single version might be hard sometimes.  That's why it seemed simpler
  to completely separate the nix expressions, too.
*/
