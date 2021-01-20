{ buildPecl, lib, pkgs }:

buildPecl {
  pname = "yaml";

  version = "2.2.0";
  sha256 = "1d65cf5vnr7brhxmy1pi2axjiyvdhmpcnq0qlx5spwlgkv6hnyml";

  configureFlags = [ "--with-yaml=${pkgs.libyaml}" ];

  nativeBuildInputs = [ pkgs.pkg-config ];

  meta.maintainers = lib.teams.php.members;
}
