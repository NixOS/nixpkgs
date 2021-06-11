{ buildPecl, lib, pkg-config, libyaml }:

buildPecl {
  pname = "yaml";

  version = "2.2.1";
  sha256 = "sha256-4XrQTnUuJf0Jm93S350m3+8YPI0AxBebydei4cl9eBk=";

  configureFlags = [ "--with-yaml=${libyaml}" ];

  nativeBuildInputs = [ pkg-config ];

  meta = with lib; {
    description = "YAML-1.1 parser and emitter";
    license = licenses.mit;
    homepage = "http://bd808.com/pecl-file_formats-yaml/";
    maintainers = teams.php.members;
  };
}
