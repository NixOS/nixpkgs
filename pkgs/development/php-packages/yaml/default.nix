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

  meta = with lib; {
    description = "YAML-1.1 parser and emitter";
    license = licenses.mit;
    homepage = "https://github.com/php/pecl-file_formats-yaml";
    maintainers = teams.php.members;
  };
}
