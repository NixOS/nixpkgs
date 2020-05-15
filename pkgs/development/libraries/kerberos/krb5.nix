{ stdenv, fetchurl, pkgconfig, perl, yacc, bootstrap_cmds
, openssl, openldap, libedit, keyutils

# Extra Arguments
, type ? ""
# This is called "staticOnly" because krb5 does not support
# builting both static and shared, see below.
, staticOnly ? false
}:

let
  libOnly = type == "lib";
in
with stdenv.lib;
stdenv.mkDerivation rec {
  name = "${type}krb5-${version}";
  majorVersion = "1.18"; # remove patches below with next upgrade
  version = majorVersion;

  src = fetchurl {
    url = "https://kerberos.org/dist/krb5/${majorVersion}/krb5-${version}.tar.gz";
    sha256 = "121c5xsy3x0i4wdkrpw62yhvji6virbh6n30ypazkp0isws3k4bk";
  };

  patches = optionals stdenv.hostPlatform.isMusl [
    # TODO: Remove with next release > 1.18
    # Patches to fix musl build with 1.18.
    # Not using `fetchpatch` for these for now to avoid infinite recursion
    # errors in downstream projects (unclear if it's a nixpkgs issue so far).
    ./krb5-Fix-Linux-build-error-with-musl-libc.patch
    ./krb5-Fix-typo-in-musl-build-fix.patch
  ];

  outputs = [ "out" "dev" ];

  configureFlags = [ "--with-tcl=no" "--localstatedir=/var/lib"]
    # krb5's ./configure does not allow passing --enable-shared and --enable-static at the same time.
    # See https://bbs.archlinux.org/viewtopic.php?pid=1576737#p1576737
    ++ optional staticOnly [ "--enable-static" "--disable-shared" ]
    ++ optional stdenv.isFreeBSD ''WARN_CFLAGS=""''
    ++ optionals (stdenv.buildPlatform != stdenv.hostPlatform)
       [ "krb5_cv_attr_constructor_destructor=yes,yes"
         "ac_cv_func_regcomp=yes"
         "ac_cv_printf_positional=yes"
       ];

  nativeBuildInputs = [ pkgconfig perl ]
    ++ optional (!libOnly) yacc
    # Provides the mig command used by the build scripts
    ++ optional stdenv.isDarwin bootstrap_cmds;

  buildInputs = [ openssl ]
    ++ optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.libc != "bionic" && !(stdenv.hostPlatform.useLLVM or false)) [ keyutils ]
    ++ optionals (!libOnly) [ openldap libedit ];

  preConfigure = "cd ./src";

  buildPhase = optionalString libOnly ''
    MAKE="make -j $NIX_BUILD_CORES -l $NIX_BUILD_CORES"
    (cd util; $MAKE)
    (cd include; $MAKE)
    (cd lib; $MAKE)
    (cd build-tools; $MAKE)
  '';

  installPhase = optionalString libOnly ''
    mkdir -p "$out"/{bin,sbin,lib/pkgconfig,share/{et,man/man1}} \
      "$dev"/include/{gssapi,gssrpc,kadm5,krb5}
    (cd util; $MAKE install)
    (cd include; $MAKE install)
    (cd lib; $MAKE install)
    (cd build-tools; $MAKE install)
    ${postInstall}
  '';

  # not via outputBin, due to reference from libkrb5.so
  postInstall = ''
    moveToOutput bin/krb5-config "$dev"
  '';

  enableParallelBuilding = true;
  doCheck = false; # fails with "No suitable file for testing purposes"

  meta = {
    description = "MIT Kerberos 5";
    homepage = "http://web.mit.edu/kerberos/";
    license = licenses.mit;
    platforms = platforms.unix ++ platforms.windows;
  };

  passthru.implementation = "krb5";
}
