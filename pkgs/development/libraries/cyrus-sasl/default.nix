{ lib, stdenv, fetchurl, openssl, openldap, kerberos, db, gettext,
  pam, fixDarwinDylibNames, autoreconfHook, fetchpatch, enableLdap ? false }:

with stdenv.lib;
stdenv.mkDerivation rec {
  name = "cyrus-sasl-${version}${optionalString (kerberos == null) "-without-kerberos"}";
  version = "2.1.26";

  src = fetchurl {
    url = "ftp://ftp.cyrusimap.org/cyrus-sasl/${name}.tar.gz";
    sha256 = "1hvvbcsg21nlncbgs0cgn3iwlnb3vannzwsp6rwvnn9ba4v53g4g";
  };

  outputs = [ "bin" "dev" "out" "man" "devdoc" ];

  buildInputs =
    [ openssl db gettext kerberos ]
    ++ lib.optional enableLdap openldap
    ++ lib.optional stdenv.isFreeBSD autoreconfHook
    ++ lib.optional stdenv.isLinux pam
    ++ lib.optional stdenv.isDarwin fixDarwinDylibNames;

  patches = [
    ./missing-size_t.patch # https://bugzilla.redhat.com/show_bug.cgi?id=906519
    (fetchpatch {
      name = "CVE-2013-4122.patch";
      url = "mirror://sourceforge/miscellaneouspa/files/glibc217/cyrus-sasl-2.1.26-glibc217-crypt.diff";
      sha256 = "05l7dh1w9d5fvzg0pjwzqh0fy4ah8y5cv6v67s4ssbq8xwd4pkf2";
    })
  ] ++ lib.optional stdenv.isFreeBSD (
      fetchurl {
        url = "http://www.linuxfromscratch.org/patches/blfs/svn/cyrus-sasl-2.1.26-fixes-3.patch";
        sha256 = "1vh4pc2rxxm6yvykx0b7kg09jbcwcxwv5rs6yq2ag3y8p6a9x86w";
      }
    );

  configureFlags = [
    "--with-openssl=${openssl.dev}"
    "--with-plugindir=${placeholder "out"}/lib/sasl2"
    "--with-saslauthd=/run/saslauthd"
    "--enable-login"
    "--enable-shared"
  ] ++ lib.optional enableLdap "--with-ldap=${openldap.dev}";

  # Avoid triggering regenerating using broken autoconf/libtool bits.
  # (many distributions carry patches to remove/replace, but this works for now)
  dontUpdateAutotoolsGnuConfigScripts = if stdenv.hostPlatform.isMusl then true else null;

  installFlags = lib.optional stdenv.isDarwin [ "framedir=$(out)/Library/Frameworks/SASL2.framework" ];

  postInstall = ''
    for f in $out/lib/*.la $out/lib/sasl2/*.la; do
      substituteInPlace $f --replace "${openssl.dev}/lib" "${openssl.out}/lib"
    done
  '';

  meta = {
    homepage = https://www.cyrusimap.org/sasl;
    description = "Library for adding authentication support to connection-based protocols";
    platforms = platforms.unix;
    license = licenses.bsdOriginal;
  };
}
