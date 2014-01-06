{ pkgs, stdenv, fetchurl, composableDerivation, autoconf, automake
, flex, bison, apacheHttpd, mysql, libxml2, readline
, zlib, curl, gd, postgresql, openssl, pkgconfig, sqlite, config, libiconv
, libjpeg, libpng, htmlTidy, libmcrypt, fcgi, callPackage, gettext
, freetype, writeText
, openldap, cyrus_sasl, libmhash
, systemd
, version ? "5.3.x" # latest stable
, icu
, libxslt
, bzip2

# options


, sapi ? "apxs2" # SAPI support: only one can be used at a time ? (PHP >= 5.3)

# keep *Support args sorted
, bcmathSupport ? true
, curlSupport ? true
, fastcgiSupport ? false
, gdSupport ? true
, gettextSupport ? true
, ldapSupport ? true
, libxml2Support ? true
, mbstringSupport ? true
, mcryptSupport ? true
, mysqlSupport ? true
, mysqliSupport ? true
, opensslSupport ? true
, pcntlSupport ? true
, pdo_mysqlSupport ? true
, postgresqlSupport ? true
, readlineSupport ? true
, soapSupport ? true
, socketsSupport ? true
, sqliteSupport ? true
, tidySupport ? true
, ttfSupport ? true
, zipSupport ? true
, zlibSupport ? true

, gdShared ? true

, fpmSystemdSocketActivationPatchSupport ? true

, idByConfig ? true # if true the php.id value will only depend on php configuration, not on the store path, eg dependencies

, lessThan53 ? builtins.lessThan (builtins.compareVersions version "5.3") 0 # you're not supposed to pass this
, lessThan54 ? builtins.lessThan (builtins.compareVersions version "5.4") 0
, lessThan55 ? builtins.lessThan (builtins.compareVersions version "5.5") 0

, sendmail ? "/var/setuid-wrappers/sendmail"
}:

/* version specific notes:
   5.2: no longer maintained - use at your own risk. php-fpm patch requires an
        /etc/php-fpm-5.2.conf file. fpm support is experimental - also options
        may no longer build

        Yes - we should discussing removing this version- however you never know when
        you need it - it still works - and there are customer still running old
        code ..

   5.3, 5.4: maintained officially. Everything which does not work is a bug

  Having all versions in one file can be considered "complicated" - but I feel
  more code is shared - so I think its the simplest way - unless configuration
  changes dramatically

  The php derivation also has special names:

  apc                   : PHP cache, might be included in PHP 6 eventually, so you might prefer this over xcache
  xcache                : another cache implementation
  xdebug                : module required to debug PHP - seems to build for all PHP versions
  system_fpm_config     : provides nixos config values providing the same "API" for PHP 5.2 and 5.3
                          See nixos module for details

  id                    : something uniq identifying PHP configure options. Its
                          used by the nixos module to find out which pools may
                          be controlled by the same daemon. Eg to reduce security risks you
                          can have special extensions enabled for some projects only.
*/

let

  true_version = if version == "5.3.x" then "5.3.28"
  else if version == "5.4.x" then "5.4.23"
  else if version == "5.5.x" then "5.5.7"
  else version;

  libxml2 = if lessThan53 then pkgs.libxml2.override { version = "2.7.8"; } else pkgs.libxml2;

  # used to calculate php id based on features
  options = [ /* sapi */ 
    # keep sorted
    "bcmathSupport"
    "curlSupport"
    "fastcgiSupport"
    "fpmSystemdSocketActivationPatchSupport"
    "gdSupport"
    "gettextSupport"
    "ldapSupport"
    "libxml2Support"
    "mbstringSupport"
    "mcryptSupport"
    "mysqlSupport"
    "mysqliSupport"
    "opensslSupport"
    "pdo_mysqlSupport"
    "postgresqlSupport"
    "pcntlSupport"
    "readlineSupport"
    "soapSupport"
    "socketsSupport"
    "sqliteSupport"
    "tidySupport"
    "ttfSupport"
    "zipSupport"
    "zlibSupport"
    ];

  # note: this derivation contains a small hack: It contains several PHP
  # versions
  # If the differences get too large this shoud be split into several files
  # At the moment this works fine for me.
  # known differences:
  # -ini location
  # PHP 5.3 does no longer support fastcgi.
  #  fpm seems to be the replacement.
  #  There exist patches for 5.2
  # PHP > 5.3 can only build one SAPI module

  inherit (composableDerivation) edf wwf;

  inherit (stdenv) lib;

  php = composableDerivation.composableDerivation {
    inherit (stdenv) mkDerivation;
  } (fixed: /* let inherit (fixed.fixed) version; in*/ {
  # Yes, this isn't properly indented.

  version = true_version;

  name = "php_configurable-${true_version}";

  buildInputs = [/*flex bison*/ pkgconfig];

  enableParallelBuilding = ! lessThan53; # php 5.2 fails with job server token error (make)

  flags = {

    mergeAttrBy = {
      preConfigure = a: b: "${a}\n${b}";
    };
    # much left to do here...

    # SAPI modules:

      apxs2 = {
        configureFlags = ["--with-apxs2=${apacheHttpd}/bin/apxs"];
        buildInputs = [apacheHttpd];
      };


      fpmSystemdSocketActivationPatch = lib.optionalAttrs (fixed.fixed.cfg.fpmSupport && !lessThan53) {
	preConfigure = ''
	export NIX_LDFLAGS="$NIX_LDFLAGS `pkg-config --libs libsystemd-daemon`"
	'';
        buildInputs = [systemd];
	patches = [
	  # wiki.php.net/rfc/socketactivation (merged both files)
	  ./systemd-socket-activation.patch
	];

      };

      fpm = {
        configureFlags = ["--enable-fpm"];
      } // (lib.optionalAttrs (true_version == "5.2.17") {
        configureFlags = [
            "--enable-fpm"
            "--enable-fastcgi"
            "--with-fpm-log=/var/log/php-fpm-5.2"
            "--with-fpm-pid=/var/run/php-fpm-5.2.pid"
            # "--with-xml-config=/etc/php-fpm-5.2.conf"
           ];

        # experimental
        patches = [(fetchurl {
                      url = http://php-fpm.org/downloads/php-5.2.17-fpm-0.5.14.diff.gz;
                      sha256 = "1v3fwiifx89y5lnj0kv4sb9yj90b4k27dfd2z3a5nw1qh5c44d2g";
                    })];

        postInstall = ''
          mv $out/etc/php-fpm.conf{,.example}
          ln -s /etc/php-fpm-5.2.conf $out/etc/php-fpm.conf
        '';
      })
      ;

      # Extensions

      ttf = {
        configureFlags = ["--enable-gd-native-ttf" "--with-ttf" "--with-freetype-dir=${freetype}"];
        buildInputs = [freetype];
      };

      curl = {
        configureFlags = ["--with-curl=${curl}" "--with-curlwrappers"];
        buildInputs = [curl openssl];
      };

      ldap = {
        configureFlags = ["--with-ldap=${openldap}" "--with-ldap-sasl=${cyrus_sasl}"];
        buildInputs = [openldap cyrus_sasl];
      };

      mhash = {
        # obsoleted by Hash, see http://php.net/manual/de/book.mhash.php ?
        configureFlags = ["--with-mhash"];
        buildInputs = [libmhash];
      };

      zlib = {
        configureFlags = ["--with-zlib=${zlib}"];
        buildInputs = [zlib];
      };

      libxml2 = {
        configureFlags = [
          "--with-libxml-dir=${libxml2}"
          "--with-iconv-dir=${libiconv}"
          ];
        buildInputs = [ libxml2 ];
      };

      pcntl = {
        configureFlags = [ "--enable-pcntl" ];
      };

      readline = {
        configureFlags = ["--with-readline=${readline}"];
        buildInputs = [ readline ];
      };
    
      sqlite = {
        configureFlags = ["--with-pdo-sqlite=${sqlite}"];
        buildInputs = [ sqlite ];
      };
    
      postgresql = {
        configureFlags = ["--with-pgsql=${postgresql}"];
        buildInputs = [ postgresql ];
      };
    
      mysql = {
        configureFlags = ["--with-mysql=${mysql}"];
        buildInputs = [ mysql ];
      };

      mysqli = {
        configureFlags = ["--with-mysqli=${mysql}/bin/mysql_config"];
        buildInputs = [ mysql];
      };

      mysqli_embedded = {
        configureFlags = ["--enable-embedded-mysqli"];
        depends = "mysqli";
        assertion = fixed.mysqliSupport;
      };

      pdo_mysql = {
        configureFlags = ["--with-pdo-mysql=${mysql}"];
        buildInputs = [ mysql ];
      };

      bcmath = {
        configureFlags = ["--enable-bcmath"];
      };

      gd = 
      let graphicLibraries = "--with-freetype-dir=${freetype} --with-png-dir=${libpng} --with-jpeg-dir=${libjpeg}"; in
      {
        configureFlags =
          if gdShared then
            # ok: ["--with-gd=${gd}"];
            # does this work with 5.3?
            ["--with-gd=shared  " graphicLibraries]
          else ["--with-gd" graphicLibraries];
        buildInputs = [gd libpng libjpeg ];
      };

      soap = {
        configureFlags = ["--enable-soap"];
      };

      sockets = {
        configureFlags = ["--enable-sockets"];
      };

      openssl = {
        configureFlags = ["--with-openssl=${openssl}"];
        buildInputs = ["openssl"];
      };

      mbstring = {
        configureFlags = ["--enable-mbstring"];
      };

      gettext = {
        configureFlags = ["--with-gettext=${gettext}"];
        preConfigure = ''
          sed -i 's@for i in \$PHP_GETTEXT /usr/local /usr; do@for i in '"$nativeBuildInputs"'; do@' configure
        '';
        buildInputs = [gettext stdenv.glibc /* libintl.h */];
      };

      fastcgi = {
        configureFlags = ["--enable-fastcgi"];
        assertion = lessThan53;
      };

      tidy = {
        configureFlags = ["--with-tidy=${htmlTidy}"];
      };

      intl = {
        configureFlags = ["--enable-intl"];
        buildInputs = [icu];
      };


      exif = {
        configureFlags = ["--enable-exif"];
      };


      xsl = {
        configureFlags = ["--with-xsl=${libxslt}"];
        buildInputs = [libxslt];
      };

      mcrypt = {
        configureFlags = ["--with-mcrypt=${libmcrypt}"];
        buildInputs = [ libmcrypt ];
      };


      bz2 = {
        configureFlags = ["--with-bz2=${bzip2}"];
        buildInputs = [bzip2];
      };

      zip = {
        configureFlags = ["--enable-zip"];
      };
      /*
         php is build within this derivation in order to add the xdebug lines to the php.ini.
         So both Apache and command line php both use xdebug without having to configure anything.
         Xdebug could be put in its own derivation.
      * /
        meta = {
                description = "debugging support for PHP";
                homepage = http://xdebug.org;
                license = "based on the PHP license - as is";
                };
      */
    };

  cfg = {
    fpmSupport = sapi == "fpm";
    apxs2Support = sapi == "apxs2";

    inherit
    bcmathSupport
    curlSupport
    fastcgiSupport
    gdSupport
    gettextSupport
    libxml2Support
    mbstringSupport
    mcryptSupport
    mysqliSupport
    mysqlSupport
    opensslSupport
    pdo_mysqlSupport
    postgresqlSupport
    readlineSupport
    soapSupport
    socketsSupport
    sqliteSupport
    tidySupport
    ttfSupport
    zipSupport
    zlibSupport
    fpmSystemdSocketActivationPatchSupport;
  };

  configurePhase = ''
    runHook "preConfigure"
    # Don't record the configure flags since this causes unnecessary
    # runtime dependencies.
    for i in main/build-defs.h.in scripts/php-config.in; do
      substituteInPlace $i \
        --replace '@CONFIGURE_COMMAND@' '(omitted)' \
        --replace '@CONFIGURE_OPTIONS@' "" \
        --replace '@PHP_LDFLAGS@' ""
    done

    iniFile=$out/etc/php-recommended.ini
    [[ -z "$libxml2" ]] || export PATH=$PATH:$libxml2/bin
    ./configure --with-config-file-scan-dir=/etc --with-config-file-path=$out/etc --prefix=$out  $configureFlags
  '';

  preBuild = ''
    sed -i 's@#define PHP_PROG_SENDMAIL	""@#define PHP_PROG_SENDMAIL	"${sendmail}"@' main/build-defs.h
  '';

  installPhase = ''
    unset installPhase; installPhase;
    cp php.ini-${ if lessThan53
        then "recommended" /* < PHP 5.3 */
        else "production" /* >= PHP 5.3 */
    } $iniFile
  '';

   src = fetchurl {
     url = "http://de2.php.net/distributions/php-${true_version}.tar.bz2";
     md5 = lib.maybeAttr true_version (throw "unkown php version ${true_version}") {
      # "5.5.0RC1" = "0b8eaea490888bc7881f60f54798f1cb";
      # "5.5.5" = "186c330c272d6322d254db9b2d18482a";
      "5.5.7" = "19d1ca0a58e192bcc133f700c7e78037";

      # does not built, due to patch?
      # "5.4.5" = "ffcc7f4dcf2b79d667fe0c110e6cb724";
      # "5.4.7" = "9cd421f1cc8fa8e7f215e44a1b06199f";
      # "5.4.14" = "cfdc044be2c582991a1fe0967898fa38";
      # "5.4.15" = "145ea5e845e910443ff1eddb3dbcf56a";
      # "5.4.19" = "f06f99b9872b503758adab5ba7a7e755";
      # "5.4.21" = "3dcf021e89b039409d0b1c346b936b5f";
      # "5.4.22" = "0a7400d1d7f1f55b2b36285bf1a00762";
      "5.4.23" = "023857598b92ea5c78137543817f4bc5";

      # those older versions are likely to be buggy - there should be no reason to compile them
      # "5.3.3" = "21ceeeb232813c10283a5ca1b4c87b48";
      # "5.3.6" = "2286f5a82a6e8397955a0025c1c2ad98";
      # "5.3.14" = "7caac4f71e2f21426c11ac153e538392";
      # "5.3.15" = "5cfcfd0fa4c4da7576f397073e7993cc";
      # "5.3.17" = "29ee79c941ee85d6c1555c176f12f7ef";
      # "5.3.18" = "52539c19d0f261560af3c030143dfa8f";
      # "5.3.24" = "9820604df98c648297dcd31ffb8214e8";
      # "5.3.25" = "347625ed7fbf2fe1f1c70b0f879fee2a";
      # "5.3.27" = "25ae23a5b9615fe8d33de5b63e1bb788";
      "5.3.28" = "56ff88934e068d142d6c0deefd1f396b";

      # 5.2 is no longer supported. However PHP 5.2 -> 5.3 has had many
      # incompatibilities which is why it may be useful to continue supporting it
      # You should use 5.3.x if possible
      "5.2.17" = "b27947f3045220faf16e4d9158cbfe13";
     };
     name = "php-${true_version}.tar.bz2";
   };

  meta = {
    description = "The PHP language runtime engine";
    homepage = http://www.php.net/;
    license = "PHP-3";
  };

  patches = 
    # TODO patch still required? I use php-fpm only
    if lessThan54
    then [./fix.patch]
    else [./fix-5.4.patch];

  });

  php_with_id = php // {
    id =
       if idByConfig && builtins ? hashString
       then # turn options into something hashable:
            let opts_s = lib.concatMapStrings (x: if x then "1" else "") (lib.attrVals options php);
            # you're never going to use that many php's at the same time, thus use a short hash
            in "${php.version}-${builtins.substring 0 5 (builtins.hashString "sha256" opts_s)}"
       else # the hash of the store path depending on php version and all configuration details
            builtins.baseNameOf (builtins.unsafeDiscardStringContext php);
  };

  in php_with_id // {
    xdebug = callPackage ../../interpreters/php-xdebug { php = php_with_id; };
    xcache = callPackage ../../libraries/php-xcache { php = php_with_id; };
    apc = callPackage ../../libraries/php-apc { php = php_with_id; };
    system_fpm_config =
          if (sapi == "fpm") then
              if lessThan53
              then config: pool: (import ./php-5.2-fpm-system-config.nix) { php = php_with_id; inherit pkgs lib writeText config pool;}
              else config: pool: (import ./php-5.3-fpm-system-config.nix) { php = php_with_id; inherit pkgs lib writeText config pool;}
          else throw "php built without fpm support. use php.override { sapi = \"fpm\"; }";
  }
