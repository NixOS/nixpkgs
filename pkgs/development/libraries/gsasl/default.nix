{ fetchurl, lib, stdenv, libidn, libkrb5 }:

stdenv.mkDerivation rec {
  pname = "gsasl";
  version = "2.2.0";

  src = fetchurl {
    url = "mirror://gnu/gsasl/${pname}-${version}.tar.gz";
    sha256 = "sha256-ebho47mXbcSE1ZspygroiXvpbOTTbTKu1dk1p6Mwd1k=";
  };

  # This is actually bug in musl. It is already fixed in trunc and
  # this patch won't be necessary with musl > 1.2.3.
  #
  # https://git.musl-libc.org/cgit/musl/commit/?id=b50eb8c36c20f967bd0ed70c0b0db38a450886ba
  patches = lib.optional stdenv.hostPlatform.isMusl ./gsasl.patch;

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
