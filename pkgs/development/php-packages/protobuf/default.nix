{ buildPecl, lib, pcre2 }:

buildPecl {
  pname = "protobuf";

  version = "3.21.4";
  sha256 = "sha256-vhfoUu63KhndfQTiITtTnaqFVF9OWMCaLf/9PUioKkQ=";

  buildInputs = [ pcre2 ];

  meta = with lib; {
    description = ''
      Google's language-neutral, platform-neutral, extensible mechanism for serializing structured data.
    '';
    license = licenses.bsd3;
    homepage = "https://developers.google.com/protocol-buffers/";
    maintainers = teams.php.members;
  };
}
