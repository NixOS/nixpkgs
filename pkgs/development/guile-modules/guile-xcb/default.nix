{ stdenv, fetchurl, pkgconfig, guile, texinfo }:

let
  name = "guile-xcb-${version}";
  version = "1.3";
in stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    url = "http://www.markwitmer.com/dist/${name}.tar.gz";
    sha256 = "04dvbqdrrs67490gn4gkq9zk8mqy3mkls2818ha4p0ckhh0pm149";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ guile texinfo ];

  preConfigure = ''
    configureFlags="
      --with-guile-site-dir=$out/share/guile/site
      --with-guile-site-ccache-dir=$out/share/guile/site
    ";
  '';

  meta = with stdenv.lib; {
    description = "XCB bindings for Guile";
    homepage = http://www.markwitmer.com/guile-xcb/guile-xcb.html;
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ vyp ];
    platforms = platforms.linux;
  };
}
