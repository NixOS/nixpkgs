{ stdenv, fetchurl, pkgconfig, guile, texinfo }:

stdenv.mkDerivation {
  name = "guile-xcb-1.3";

  meta = with stdenv.lib; {
    description = "XCB bindings for Guile";
    homepage    = "http://www.markwitmer.com/guile-xcb/guile-xcb.html";
    license     = licenses.gpl3Plus;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ iyzsong ];
  };

  src = fetchurl {
    url = "http://www.markwitmer.com/dist/guile-xcb-1.3.tar.gz";
    sha256 = "04dvbqdrrs67490gn4gkq9zk8mqy3mkls2818ha4p0ckhh0pm149";
  };

  buildInputs = [ pkgconfig guile texinfo ];

  preConfigure = ''
    configureFlags="
      --with-guile-site-dir=$out/share/guile/site
      --with-guile-site-ccache-dir=$out/share/guile/site
    ";
  '';
}
