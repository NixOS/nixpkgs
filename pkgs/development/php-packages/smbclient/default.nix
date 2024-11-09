{
  buildPecl,
  lib,
  samba,
  pkg-config,
}:
buildPecl {
  pname = "smbclient";
  version = "1.0.6";
  sha256 = "sha256-ZsQzdDt6NLRWBsA75om9zkxSvB6zBsvvPhXJZrX/KNc=";

  # TODO: remove this when upstream merges a fix - https://github.com/eduardok/libsmbclient-php/pull/66
  LIBSMBCLIENT_INCDIR = "${samba.dev}/include/samba-4.0";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ samba ];

  meta = with lib; {
    description = "PHP wrapper for libsmbclient";
    license = licenses.bsd2;
    homepage = "https://github.com/eduardok/libsmbclient-php";
    maintainers = teams.php.members;
  };
}
