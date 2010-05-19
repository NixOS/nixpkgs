{stdenv, fetchurl, libxml2, postgresql, geos, proj, perl}:

# TODO: the bin commands to have gtk gui
# compile this optionally ?

# NixOS - usage: services.posgresql.extraPlugins = [ pkgs.postgis ];

stdenv.mkDerivation {
  name = "postgis";

  src = fetchurl {
    url = http://postgis.refractions.net/download/postgis-1.5.1.tar.gz;
    sha256 = "0nymvqqi6pp4nh4dcshzqm76x4sraf119jp7l27c2q1lygm6p6jr";
  };

  makeFlags = "PERL=${perl}/bin/perl";

  # default both defaul to postgis location !?
  preConfigure = ''
    configureFlags="--datadir=$out/share --datarootdir=$out/share --bindir=$out/bin"
    makeFlags="PERL=${perl}/bin/perl datadir=$out/share pkglibdir=$out/lib bindir=$out/bin"

  #  makeFlags="DESTDIR=$out "
  '';

  # create a script enabling postgis features
  postInstall = ''
    cat >> $out/bin/enable_postgis_for_db << EOF
    #!/bin/sh
    set -x
    t=$out/share/contrib/postgis-1.5
    for db in "\$@"; do
      createlang plpgsql \$db
      for f in postgis spatial_ref_sys; do
        psql -d \$db -f \$t/\$f.sql
      done
    done
    EOF
    chmod +x $out/bin/enable_postgis_for_db
  '';

  buildInputs = [libxml2 postgresql geos proj perl];

  meta = {
    description = "Geographic Objects for PostgreSQL";
    homepage = "http://postgis.refractions.net";
    license = "GPLv2";
    maintainers = [stdenv.lib.maintainers.marcweber];
    platforms = stdenv.lib.platforms.linux;
  };
}
