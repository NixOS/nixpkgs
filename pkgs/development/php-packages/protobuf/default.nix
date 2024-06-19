{
  buildPecl,
  lib,
  pcre2,
}:

buildPecl {
  pname = "protobuf";

  version = "3.21.9";
  sha256 = "05zlq9k6c45wj1286850nl31024ik158jnj1f5kskr1pchknnsf3";

  buildInputs = [ pcre2 ];

  meta = with lib; {
    description = "Google's language-neutral, platform-neutral, extensible mechanism for serializing structured data.";
    license = licenses.bsd3;
    homepage = "https://developers.google.com/protocol-buffers/";
    maintainers = teams.php.members;
  };
}
