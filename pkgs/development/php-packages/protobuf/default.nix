{ buildPecl, lib, pcre2 }:

buildPecl {
  pname = "protobuf";

  version = "3.19.1";
  sha256 = "sha256-kAPNPnvbCrmGITM3Hjpsn62TASV8eNCizFN8+1+I6bY=";

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
