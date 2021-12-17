{ buildPecl, lib, pkg-config, libyaml }:

buildPecl {
  pname = "yaml";

  version = "2.2.2";
  sha256 = "sha256-EZBS8EYdV9hvRMJS+cmy3XQ0hscBwaCroK6+zdDYuCo=";

  configureFlags = [ "--with-yaml=${libyaml}" ];

  nativeBuildInputs = [ pkg-config ];

  meta = with lib; {
    description = "YAML-1.1 parser and emitter";
    license = licenses.mit;
    homepage = "http://bd808.com/pecl-file_formats-yaml/";
    maintainers = teams.php.members;
  };
}
