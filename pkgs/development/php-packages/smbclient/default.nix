{
  buildPecl,
  lib,
  samba,
  pkg-config,
}:
buildPecl {
  pname = "smbclient";
  version = "1.1.2";
  sha256 = "sha256-Hmp0RWOqxwCBXlca2YsRNahOhA1E5qxnmXSUx4Cpzec=";

  # TODO: remove this when upstream merges a fix - https://github.com/eduardok/libsmbclient-php/pull/66
  LIBSMBCLIENT_INCDIR = "${samba.dev}/include/samba-4.0";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ samba ];

  meta = {
    description = "PHP wrapper for libsmbclient";
    license = lib.licenses.bsd2;
    homepage = "https://github.com/eduardok/libsmbclient-php";
    teams = [ lib.teams.php ];
  };
}
