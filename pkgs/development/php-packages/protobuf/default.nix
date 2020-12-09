{ buildPecl, lib, pcre' }:

buildPecl {
  pname = "protobuf";

  version = "3.14.0";
  sha256 = "1ldc4s28hq61cfg8l4c06pgicj0ng7k37f28a0dnnbs7xkr7cibd";

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
