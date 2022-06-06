{ lib
, stdenv
, fetchurl
, fetchpatch

# dependencies
, cyrus_sasl
, db
, groff
, libsodium
, libtool
, openssl
, systemdMinimal
}:

stdenv.mkDerivation rec {
  pname = "openldap";
  version = "2.6.2";

  src = fetchurl {
    url = "https://www.openldap.org/software/download/OpenLDAP/openldap-release/${pname}-${version}.tgz";
    hash = "sha256-gdCTRSMutiSG7PWsrNLFbAxFtKbIwGZhLn9CGiOhz4c";
  };

  patches = [
    # ITS#9840 - ldif-filter: fix parallel build failure
    (fetchpatch {
      url = "https://github.com/openldap/openldap/commit/7d977f51e6dfa570a471d163b9e8255bdd3dc12f.patch";
      hash = "sha256:1vid6pj2gmqywbghnd380x19ml241ldc1fyslb6br6q27zpgbdlp";
    })
    # ITS#9840 - libraries/Makefile.in: ignore the mkdir errors
    (fetchpatch {
      url = "https://github.com/openldap/openldap/commit/71f24015c312171c00ce94c9ff9b9c6664bdca8d.patch";
      hash = "sha256:1a81vv6nkhgiadnj4g1wyzgzdp2zd151h0vkwvv9gzmqvhwcnc04";
    })
    # ITS#7165 back-mdb: check for stale readers on
    (fetchpatch {
      url = "https://github.com/openldap/openldap/commit/7e7f01c301db454e8c507999c77b55a1d97efc21.patch";
      hash = "sha256:1fc2yck2gn3zlpfqjdn56ar206npi8cmb8yg5ny4lww0ygmyzdfz";
    })
    # ITS#9858 back-mdb: delay indexer task startup
    (fetchpatch {
      url = "https://github.com/openldap/openldap/commit/ac061c684cc79d64ab4089fe3020921a0064a307.patch";
      hash = "sha256:01f0y50zlcj6n5mfkmb0di4p5vrlgn31zccx4a9k5m8vzxaqmw9d";
    })
    # ITS#9858 back-mdb: fix index reconfig
    (fetchpatch {
      url = "https://github.com/openldap/openldap/commit/c43c7a937cfb3a781f99b458b7ad71eb564a2bc2.patch";
      hash = "sha256:02yh0c8cyx14iir5qhfam5shrg5d3115s2nv0pmqdj6najrqc5mm";
    })
    # ITS#9157: check for NULL ld
    (fetchpatch {
      url = "https://github.com/openldap/openldap/commit/6675535cd6ad01f9519ecd5d75061a74bdf095c7.patch";
      hash = "sha256:0dali5ifcwba8400s065f0fizl9h44i0mzb06qgxhygff6yfrgif";
    })
  ];

  # TODO: separate "out" and "bin"
  outputs = [
    "out"
    "dev"
    "man"
    "devdoc"
  ];

  enableParallelBuilding = true;

  nativeBuildInputs = [
    groff
  ];

  buildInputs = [
    cyrus_sasl
    db
    libsodium
    libtool
    openssl
  ] ++ lib.optionals (stdenv.isLinux) [
    systemdMinimal
  ];

  preConfigure = lib.optionalString (lib.versionAtLeast stdenv.hostPlatform.darwinMinVersion "11") ''
    MACOSX_DEPLOYMENT_TARGET=10.16
  '';

  configureFlags = [
    "--enable-argon2"
    "--enable-crypt"
    "--enable-modules"
    "--enable-overlays"
  ] ++ lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    "--with-yielding_select=yes"
    "ac_cv_func_memcmp_working=yes"
  ] ++ lib.optional stdenv.isFreeBSD "--with-pic";

  makeFlags = [
    "CC=${stdenv.cc.targetPrefix}cc"
    "STRIP="  # Disable install stripping as it breaks cross-compiling. We strip binaries anyway in fixupPhase.
    "prefix=${placeholder "out"}"
    "sysconfdir=${placeholder "out"}/etc"
    "systemdsystemunitdir=${placeholder "out"}/lib/systemd/system"
    # contrib modules require these
    "moduledir=${placeholder "out"}/lib/modules"
    "mandir=${placeholder "out"}/share/man"
  ] ++ lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [
    # Can be unconditional, doing it like this to prevent a mass rebuild.
    "STRIP_OPTS="
  ];

  extraContribModules = [
    # https://git.openldap.org/openldap/openldap/-/tree/master/contrib/slapd-modules
    "passwd/sha2"
    "passwd/pbkdf2"
    "passwd/totp"
  ];

  postBuild = ''
    for module in $extraContribModules; do
      make $makeFlags CC=$CC -C contrib/slapd-modules/$module
    done
  '';

  preCheck = ''
    substituteInPlace tests/scripts/all \
      --replace "/bin/rm" "rm"
  '';

  doCheck = true;

  # The directory is empty and serve no purpose.
  preFixup = ''
    rm -r $out/var
  '';

  installFlags = [
    "prefix=${placeholder "out"}"
    "moduledir=${placeholder "out"}/lib/modules"
    "INSTALL=install"
  ];

  postInstall = ''
    for module in $extraContribModules; do
      make $installFlags install -C contrib/slapd-modules/$module
    done
    chmod +x "$out"/lib/*.{so,dylib}
  '';

  meta = with lib; {
    homepage = "https://www.openldap.org/";
    description = "An open source implementation of the Lightweight Directory Access Protocol";
    license = licenses.openldap;
    maintainers = with maintainers; [ ajs124 das_j hexa ];
    platforms = platforms.unix;
  };
}
