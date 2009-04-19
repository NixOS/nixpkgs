{ stdenv, fetchurl, pkgconfig, gnome, cairo
, ghc, mtl
}:

stdenv.mkDerivation rec {
  pname = "gtk2hs";
  version = "0.10.0";
  fname = "${pname}-${version}";
  name = "haskell-${pname}-ghc${ghc.ghc.version}-${version}";
  
  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${fname}.tar.gz";
    sha256 = "03ii8j13cphjpw23nnyp0idxqgd2r8m4f2jpb251g7vxrb56dw0v";
  };

  propagatedBuildInputs = [mtl];

  buildInputs = [
    pkgconfig cairo gnome.glib gnome.gtk gnome.libglade gnome.GConf
    gnome.gtksourceview_24 gnome.librsvg
    ghc
  ];

  postInstall =
    ''
      local confDir=$out/lib/ghc-pkgs/ghc-${ghc.ghc.version}
      ensureDir $confDir
      cp $out/lib/gtk2hs/*.conf $confDir/
    ''; # */
}
