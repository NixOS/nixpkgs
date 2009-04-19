{ stdenv, fetchurl, pkgconfig, gnome, cairo, ghc, mtl }:

let gtksourceview = gnome.gtksourceview_24; in

stdenv.mkDerivation rec {
  pname = "gtk2hs";
  version = "0.10.0";
  fname = "${pname}-${version}";
  name = "haskell-${pname}-ghc${ghc.ghc.version}-${version}";
  
  src = fetchurl {
    url = http://nixos.org/tarballs/gtk2hs-0.10.0-20090419.tar.gz;
    sha256 = "18a7cfph83yvv91ks37nrgqrn21fvww8bhb8nd8xy1mgb8lnfds1";
  };
  
  propagatedBuildInputs = [mtl];

  buildInputs = [
    pkgconfig cairo ghc gnome.glib gnome.gtk gnome.libglade
    gnome.GConf gtksourceview gnome.librsvg
  ];

  postInstall =
    ''
      local confDir=$out/lib/ghc-pkgs/ghc-${ghc.ghc.version}
      ensureDir $confDir
      cp $out/lib/gtk2hs/*.conf $confDir/
    ''; # */

  passthru = { inherit gtksourceview; };
}
