{ buildPecl, lib, pcre2 }:

buildPecl {
  pname = "protobuf";

  version = "3.19.4";
  sha256 = "sha256-ijo+UZz+Hh3F8FUJmcUIbKBLkv4t4CWIrbRUfUp7Zbo=";

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
