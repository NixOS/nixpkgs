{ buildPecl, lib, pcre2 }:

buildPecl {
  pname = "protobuf";

  version = "3.21.6";
  sha256 = "sha256-vyJbWsY/adrMK2PLdu+Zm1paopY+5qct2Y2AS2a70gg=";

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
