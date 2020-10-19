{ buildPecl, lib, pkgs }:

buildPecl {
  pname = "yaml";

  version = "2.0.4";
  sha256 = "1036zhc5yskdfymyk8jhwc34kvkvsn5kaf50336153v4dqwb11lp";

  configureFlags = [ "--with-yaml=${pkgs.libyaml}" ];

  nativeBuildInputs = [ pkgs.pkgconfig ];

  meta.maintainers = lib.teams.php.members;
}
