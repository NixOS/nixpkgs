{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, gettext, gtk-doc, libxslt, docbook_xsl
, python3, pcre, gmp, mpfr
}:

let
  version = "1.2";
in stdenv.mkDerivation rec {
  name = "libbytesize-${version}";

  src = fetchFromGitHub {
    owner = "storaged-project";
    repo = "libbytesize";
    rev = version;
    sha256 = "0r71ml7qjfai08rr1hk61lmf5h3niwy9f1x5xq9k76ccls6gixmc";
  };

  outputs = [ "out" "dev" "devdoc" ];

  nativeBuildInputs = [ autoreconfHook pkgconfig gettext gtk-doc libxslt docbook_xsl python3 ];

  buildInputs = [ pcre gmp mpfr ];

  meta = with stdenv.lib; {
    description = "A tiny library providing a C “class” for working with arbitrary big sizes in bytes";
    homepage = src.meta.homepage;
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [];
    platforms = platforms.linux;
  };
}
