{ lib, stdenv, fetchFromGitHub, autoreconfHook,
  libtool, pkg-config, re2, texinfo }:

stdenv.mkDerivation rec {
  pname = "cre2";
  version = "0.3.6";

  src = fetchFromGitHub {
    owner = "marcomaggi";
    repo = pname;
    rev = "v${version}";
    sha256 = "1h9jwn6z8kjf4agla85b5xf7gfkdwncp0mfd8zwk98jkm8y2qx9q";
  };

  nativeBuildInputs = [
    autoreconfHook
    libtool
    pkg-config
  ];
  buildInputs = [ re2 texinfo ];

  NIX_LDFLAGS="-lre2 -lpthread";

  configureFlags = [
    "--enable-maintainer-mode"
  ];

  meta = with lib; {
    homepage = "http://marcomaggi.github.io/docs/cre2.html";
    description = "C Wrapper for RE2";
    license = licenses.bsd3;
    platforms = platforms.all;
  };
}
