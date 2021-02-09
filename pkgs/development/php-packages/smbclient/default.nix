{ buildPecl, lib, pkgs }:
buildPecl {
  pname = "smbclient";
  version = "1.0.4";
  sha256 = "07p72m5kbdyp3r1mfxhiayzdvymhc8afwcxa9s86m96sxbmlbbp8";

  # TODO: remove this when upstream merges a fix - https://github.com/eduardok/libsmbclient-php/pull/66
  LIBSMBCLIENT_INCDIR = "${pkgs.samba.dev}/include/samba-4.0";

  nativeBuildInputs = [ pkgs.pkg-config ];
  buildInputs = [ pkgs.samba ];

  meta.maintainers = lib.teams.php.members;
}
