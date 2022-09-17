{ buildPecl, lib, pcre2 }:

buildPecl {
  pname = "protobuf";

  version = "3.21.5";
  sha256 = "sha256-B8ytFyUJ8fLBwHmaKXxfOy0h6tRELjqc5IxUUl/YU5w=";

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
