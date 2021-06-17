{ buildPecl, lib, pcre2 }:

buildPecl {
  pname = "protobuf";

  version = "3.17.2";
  sha256 = "0i4npj4sl8ihkzxc6m3vv3nlqk952z9bfwnrk90a9yakw5gfhlz5";

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
