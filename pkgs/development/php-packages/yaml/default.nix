{ buildPecl, lib, pkgs }:

buildPecl {
  pname = "yaml";

  version = "2.1.0";
  sha256 = "0rmn2irzny24ivzc09ss46s2s48i0zy2cww7ikphljqbfx6zdjss";

  configureFlags = [ "--with-yaml=${pkgs.libyaml}" ];

  nativeBuildInputs = [ pkgs.pkgconfig ];

  meta.maintainers = lib.teams.php.members;
}
