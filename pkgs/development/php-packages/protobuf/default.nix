{ buildPecl, lib, pcre' }:

buildPecl {
  pname = "protobuf";

  version = "3.11.2";
  sha256 = "0bhdykdyk58ywqj940zb7jyvrlgdr6hdb4s8kn79fz3p0i79l9hz";

  buildInputs = [ pcre' ];

  meta = with lib; {
    description = ''
      Google's language-neutral, platform-neutral, extensible mechanism for serializing structured data.
    '';
    license = licenses.bsd3;
    homepage = "https://developers.google.com/protocol-buffers/";
    maintainers = teams.php.members;
  };
}
