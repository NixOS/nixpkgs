{ buildPecl, lib, samba, pkg-config }:
buildPecl {
  pname = "smbclient";
  version = "1.0.5";
  sha256 = "sha256-cNvTa1qzYrlhuX4oNehXt+XKqmqfonyomW/usQdQQO0=";

  # TODO: remove this when upstream merges a fix - https://github.com/eduardok/libsmbclient-php/pull/66
  LIBSMBCLIENT_INCDIR = "${samba.dev}/include/samba-4.0";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ samba ];

  meta.maintainers = lib.teams.php.members;
}
