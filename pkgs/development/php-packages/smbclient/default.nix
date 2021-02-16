{ buildPecl, lib, pkgs }:
buildPecl {
  pname = "smbclient";
  version = "1.0.5";
  sha256 = "sha256-cNvTa1qzYrlhuX4oNehXt+XKqmqfonyomW/usQdQQO0=";

  # TODO: remove this when upstream merges a fix - https://github.com/eduardok/libsmbclient-php/pull/66
  LIBSMBCLIENT_INCDIR = "${pkgs.samba.dev}/include/samba-4.0";

  nativeBuildInputs = [ pkgs.pkg-config ];
  buildInputs = [ pkgs.samba ];

  meta.maintainers = lib.teams.php.members;
}
