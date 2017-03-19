{ stdenv, fetchFromGitHub, autoconf, automake,
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
    autoconf
    automake
    libtool
    pkgconfig
    re2
    texinfo
  ];

  NIX_LDFLAGS="-lre2 -lpthread";

  preConfigure = "sh autogen.sh";
  
  configureFlags = [
    "--enable-maintainer-mode"
  ];

  meta = {
    homepage = http://marcomaggi.github.io/docs/cre2.html;
    description = "C Wrapper for RE2";
    license = stdenv.lib.licenses.bsd3;
    platforms = with stdenv.lib.platforms; all;
  };
}
