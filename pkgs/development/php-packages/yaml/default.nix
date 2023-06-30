{ buildPecl, lib, pkg-config, libyaml }:

buildPecl {
  pname = "yaml";

  version = "2.2.3";
  sha256 = "sha256-WTfrlyLd9tZGJnmc+gJFmP8kUuoVeZLk5nMxolP5AjY=";

  configureFlags = [ "--with-yaml=${libyaml}" ];

  nativeBuildInputs = [ pkg-config ];

  meta = {
    description = "YAML-1.1 parser and emitter";
    license = lib.licenses.mit;
    homepage = "https://github.com/php/pecl-file_formats-yaml";
    maintainers = lib.teams.php.members;
  };
}
