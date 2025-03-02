{
  lib,
  fetchurl,
  openldap,
  buildPerlPackage,
}:

buildPerlPackage rec {
  pname = "Mozilla-Ldap";
  version = "1.5.3";
  USE_OPENLDAP = 1;
  LDAPSDKDIR = openldap.dev;
  LDAPSDKLIBDIR = "${openldap.out}/lib";
  src = fetchurl {
    url = "https://ftp.mozilla.org/pub/directory/perldap/releases/${version}/src/perl-mozldap-${version}.tar.gz";
    sha256 = "0s0albdw0zvg3w37s7is7gddr4mqwicjxxsy400n1p96l7ipnw4x";
  };
  meta = {
    description = "Mozilla's ldap client library";
    homepage = "https://metacpan.org/release/perldap";
    license = with lib.licenses; [
      mpl20
      lgpl21Plus
      gpl2Plus
    ];
  };
}
