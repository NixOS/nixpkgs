{ buildPecl, lib, pcre2 }:

buildPecl {
  pname = "protobuf";

  version = "3.17.3";
  sha256 = "05nn6ps271vwrbr9w08lyyzsszabnqhz1x0vbblg0q8y2xrmb6dl";

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
