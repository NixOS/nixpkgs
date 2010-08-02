{ stdenv, fetchurl, pkgconfig, gnome, cairo, ghc, mtl }:

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
    gnome.GConf gnome.gtksourceview gnome.librsvg
  ];

  preConfigure =
    ''
      sed -i gio/gio.package.conf.in -e 's|@GIO_LIBDIR_CQ@|"${gnome.glib}/lib", "${gnome.glib}/lib64", @GIO_LIBDIR_CQ@|'
      sed -i gtk/gtk.package.conf.in -e 's|@GTK_LIBDIR_CQ@|"${gnome.glib}/lib", "${gnome.glib}/lib64", @GTK_LIBDIR_CQ@|'
    '';

  configureFlags = ["--without-pkgreg"];

  postInstall =
    ''
      local confDir=$out/lib/ghc-pkgs/ghc-${ghc.ghc.version}
      local installedPkgConf=$confDir/${fname}.installedconf
      ensureDir $out/bin # necessary to get it added to PATH
      ensureDir $confDir
      echo $installedPkgConf
      echo '[]' > $installedPkgConf
      for pkgConf in $out/lib/gtk2hs/*.conf; do
        cp $pkgConf $confDir/
        GHC_PACKAGE_PATH=$installedPkgConf ghc-pkg --global register $pkgConf --force
      done
    ''; # */

  passthru = { inherit (gnome) gtksourceview; };
}
