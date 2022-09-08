{ fetchurl, lib, stdenv, libidn, libkrb5 }:

stdenv.mkDerivation rec {
  pname = "gsasl";
  version = "2.0.1";

  src = fetchurl {
    url = "mirror://gnu/gsasl/${pname}-${version}.tar.gz";
    sha256 = "sha256-Mix1QgCIQbzYukrgkzsiAhHRkKe1anDdYfZVbezAG3o=";
  };

  buildInputs = [ libidn libkrb5 ];

  configureFlags = [ "--with-gssapi-impl=mit" ];

  preCheck = ''
    export LOCALDOMAIN="dummydomain"
  '';
  doCheck = !stdenv.hostPlatform.isDarwin;

  meta = {
    description = "GNU SASL, Simple Authentication and Security Layer library";

    longDescription =
      '' GNU SASL is a library that implements the IETF Simple
         Authentication and Security Layer (SASL) framework and
         some SASL mechanisms. SASL is used in network servers
         (e.g. IMAP, SMTP, etc.) to authenticate peers.
       '';

    homepage = "https://www.gnu.org/software/gsasl/";
    license = lib.licenses.gpl3Plus;

    maintainers = with lib.maintainers; [ shlevy ];
    platforms = lib.platforms.all;
  };
}
