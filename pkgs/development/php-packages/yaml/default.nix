{
  buildPecl,
  lib,
  libyaml,
}:

buildPecl {
  pname = "yaml";

  version = "2.2.4";
  sha256 = "sha256-jrNTuvh/FbG2Ksbrcci1iWhZWKH+iw49IqxZVg0OiRM=";

  configureFlags = [ "--with-yaml=${libyaml.dev}" ];

  buildInputs = [
    libyaml
  ];

  meta = {
    description = "YAML-1.1 parser and emitter";
    license = lib.licenses.mit;
    homepage = "https://github.com/php/pecl-file_formats-yaml";
    maintainers = lib.teams.php.members;
  };
}
