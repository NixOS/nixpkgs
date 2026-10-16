{
  buildPecl,
  lib,
  php,
  libyaml,
}:

buildPecl {
  pname = "yaml";

  version = "2.2.5";
  sha256 = "sha256-DHUbSJdJ+/AgcdWwxr/rJsS4Y8Zo74lxHs+VBzkb33E=";

  configureFlags = [ "--with-yaml=${libyaml.dev}" ];

  buildInputs = [
    libyaml
  ];

  meta = {
    broken = lib.versionAtLeast php.version "8.6";
    description = "YAML-1.1 parser and emitter";
    license = lib.licenses.mit;
    homepage = "https://github.com/php/pecl-file_formats-yaml";
    teams = [ lib.teams.php ];
  };
}
