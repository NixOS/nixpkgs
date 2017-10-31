{ stdenv, fetchFromGitHub, autoreconfHook,
  libtool, pkgconfig, re2, texinfo }:

stdenv.mkDerivation rec {
  name = "cre2-${version}";
  version = "0.3.0";
    
  src = fetchFromGitHub {
    owner = "marcomaggi";
    repo = "cre2";
    rev = version;
    sha256 = "12yrdad87jjqrhbqm02hzsayan2402vf61a9x1b2iabv6d1c1bnj";
  };

  nativeBuildInputs = [
    autoreconfHook
    libtool
    pkgconfig
  ];
  buildInputs = [ re2 texinfo ];

  NIX_LDFLAGS="-lre2 -lpthread";

  configureFlags = [
    "--enable-maintainer-mode"
  ];

  meta = with stdenv.lib; {
    homepage = http://marcomaggi.github.io/docs/cre2.html;
    description = "C Wrapper for RE2";
    license = licenses.bsd3;
    platforms = platforms.all;
  };
}
