args@{fetchurl, composableDerivation, stdenv, perl, libxml2, postgresql, geos, proj, flex, ...}:

  /*

  ### NixOS - usage:
  ==================

    services.posgresql.extraPlugins = [ pkgs.postgis.v_1_5_1 ];

    or if you want to install 1.5.x and 1.3.x at the same time (which works
    because the .sql and .so files have different names):

    services.postgis.extraPlugins = [ (pkgs.buildEnv {
          name = "postgis-plugins";
          ignoreCollisions = 1; # scripts will collide - but there are aliases with version suffixes
          paths = [ pkgs.postgis.v_1_3_5 pkgs.postgis.v_1_5_1 ];
        })];

    By now it is only supported installing one of the 1.3.x verions because
    their shared libraries don't differ in naming.



  ### important Postgis implementation details:
  =============================================

    Postgis provides a shared library implementing many operations. They are
    exposed to the Postgres SQL interpreter by special SQL queries eg:

      CREATE FUNCTION [...]
              AS '[..]liblwgeom', 'lwhistogram2d_in' LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict);
    
   where liblwgeom is the shared library.
   Postgis < 1.5 used absolute paths, in NixOS $libdir is always used.

   Thus if you want to use postgresql dumps which were created by non NixOS
   systems you have to adopt the library path.



   ### TODO:
   =========
   the bin commands to have gtk gui:
  */


let
  pgDerivationBase = composableDerivation.composableDerivation {} ( fix :

  let version = fix.fixed.version; in {

    name = "postgis-${version}";

    src = fetchurl {
      url = "http://postgis.refractions.net/download/postgis-${fix.fixed.version}.tar.gz";
      inherit (fix.fixed) sha256;
    };

    # don't pass these vars to the builder
    removeAttrs = ["hash" "sql_comments" "sql_srcs"];

    preConfigure = ''
      configureFlags="--datadir=$out/share --datarootdir=$out/share --bindir=$out/bin"
      makeFlags="PERL=${perl}/bin/perl datadir=$out/share pkglibdir=$out/lib bindir=$out/bin"
    '';

    pg_db_postgis_enable = ./pg_db_postgis_enable.sh;

    scriptNames = [ "pg_db_postgis_enable" ]; # helper scripts

    # prepare fixed parameters for script and create pg_db_postgis_enable script.
    # The script just loads postgis features into a list of given databases
    postgisEnableScript = ''
      s=$out/bin/pg_db_postgis_enable

      sql_comments=$out/share/postgis-${version}/comments.sql
      mkdir -p $(dirname $sql_comments)
      cp $(find -iname ${fix.fixed.sql_comments}) $sql_comments

      for script in $scriptNames; do
        tg=$out/bin/$script
        substituteAll ''${!script} $tg
        chmod +x $tg
      done
    '';

    # create a script enabling postgis features
    # also create aliases for all commands adding version information
    postInstall = ''

      sql_srcs=$(for sql in ${builtins.toString fix.fixed.sql_srcs}; do echo -n "$(find $out -iname "$sql") "; done )

      eval "$postgisEnableScript"
      eval "$postgisFixLibScript"

      for prog in $out/bin/*; do
        ln -s $prog $prog-${version}
      done

      cp -r doc $out
    '';

    buildInputs = [libxml2 postgresql geos proj perl];

    sql_comments = "postgis_comments.sql";

    meta = {
      description = "Geographic Objects for PostgreSQL";
      homepage = "http://postgis.refractions.net";
      license = stdenv.lib.licenses.gpl2;
      maintainers = [stdenv.lib.maintainers.marcweber];
      platforms = stdenv.lib.platforms.linux;
    };
  });


in rec {

  # these builders just add some custom informaton to the receipe above

  v_1_3_5 = pgDerivationBase.merge ( fix: {
    version = "1.3.5";
    buildInputs = [ flex ];
    sha256 = "102d5ybn0db1wrb249dga2v8347vysd4f1brc8zb82d7vdd34wyq";
    sql_srcs = ["lwpostgis.sql" "spatial_ref_sys.sql"];

    pg_db_postgis_fix_or_load_sql_dump = ./pg_db_postgis_fix_or_load_sql_dump.sh;
    libName = "liblwgeom";
    scriptNames = [ "pg_db_postgis_enable" "pg_db_postgis_fix_or_load_sql_dump"]; # helper scripts

    # sql_srcs is defined in postInstall source above
    # if store path changes sql should not break. So replace absolute path to
    # shared library by path relatve to $libdir known by Postgres.
    postInstall = ''
      sed -i "s@AS '$out/lib/liblwgeom@AS '\$libdir/liblwgeom@" $sql_srcs $out/share/lwpostgis_upgrade.sql
    '';
  });

  v_1_3_6 = v_1_3_5.merge ({
    version = "1.3.6";
    sha256 = "0i6inyiwc5zgf5a4ssg0y774f8vn45zn5c38ccgnln9r6i54vc6k";
  });

  v_1_5_1 = pgDerivationBase.merge ( fix : {
    version = "1.5.1";
    sha256 = "0nymvqqi6pp4nh4dcshzqm76x4sraf119jp7l27c2q1lygm6p6jr";
    sql_srcs = ["postgis.sql" "spatial_ref_sys.sql"];
  });

}
