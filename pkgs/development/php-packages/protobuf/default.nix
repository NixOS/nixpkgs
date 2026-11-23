{
  buildPecl,
  lib,
  php,
  pcre2,
}:

buildPecl {
  pname = "protobuf";

  version = "5.36.2";
  sha256 = "sha256-8KF8Z94p3w+w5SFaOB35sVUSXhrOYlLdYXvxa0GU3Vs=";

  buildInputs = [ pcre2 ];

  meta = {
    broken = lib.versionAtLeast php.version "8.6";
    description = "Google's language-neutral, platform-neutral, extensible mechanism for serializing structured data";
    license = lib.licenses.bsd3;
    homepage = "https://developers.google.com/protocol-buffers/";
    teams = [ lib.teams.php ];
  };
}
