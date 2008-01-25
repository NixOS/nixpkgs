{stdenv, fetchurl, pkgconfig, ghc, gtk, cairo, GConf, libglade
, glib, libgtkhtml, gtkhtml}:

stdenv.mkDerivation (rec {
  pname = "gtk2hs";
  version = "0.9.12.1";
  fname = "${pname}-${version}";
  name = "haskell-${fname}";
  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${fname}.tar.gz";
    sha256 = "110z6v9gzhg6nzlz5gs8aafmipbva6rc50b8z1jgq0k2g25hfy22";
  };

  buildInputs = [pkgconfig ghc gtk glib cairo GConf libglade libgtkhtml gtkhtml];

  configureFlags = [
    "--enable-cairo"
  ];

})
