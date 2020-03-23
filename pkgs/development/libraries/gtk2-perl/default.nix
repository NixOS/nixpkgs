{stdenv, fetchurl, bash, perl, gtk2, gtk2-x11, perlPackages}:

stdenv.mkDerivation rec {
  pname = "gtk2-perl";
  version = "1.24993";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/Gtk2/${version}/Gtk2-${version}.tar.gz";
    sha256 = "0ry9jfvfgdwzalxcvwsgr7plhk3agx7p40l0fqdf3vrf7ds47i29";
  };

  enableParallelBuilding = false;
  doCheck = false;

 perlDeps = [
    perl
    perlPackages.ExtUtilsDepends
    perlPackages.ExtUtilsPkgConfig
    perlPackages.Pango
    perlPackages.Glib
    perlPackages.Cairo
 ];

  buildInputs = perlDeps ++ [ gtk2 gtk2-x11 ];

  buildPhase = ''
    tar xvfz $src
    
    PERL5LIB=$PERL5LIB
    export PERL5LIB
    perl Makefile.PL PREFIX=$out
    make
  '';

  meta = with stdenv.lib; {
    homepage = "https://sourceforge.net/projects/gtk2-perl/";
    description = "Perl bindings for Gtk+ 2.x";
    license = licenses.lgpl2;
    platforms = platforms.all;
  };
  
  inherit perl;
  inherit (perlPackages) Gtk2;
  inherit gtk2;
  inherit gtk2-x11;
}

