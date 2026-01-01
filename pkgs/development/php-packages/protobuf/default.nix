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

<<<<<<< HEAD
  meta = {
    description = "Google's language-neutral, platform-neutral, extensible mechanism for serializing structured data";
    license = lib.licenses.bsd3;
    homepage = "https://developers.google.com/protocol-buffers/";
    teams = [ lib.teams.php ];
=======
  meta = with lib; {
    description = "Google's language-neutral, platform-neutral, extensible mechanism for serializing structured data";
    license = licenses.bsd3;
    homepage = "https://developers.google.com/protocol-buffers/";
    teams = [ teams.php ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
