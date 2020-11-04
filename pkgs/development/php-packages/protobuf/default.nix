{ buildPecl, lib, pcre' }:

buildPecl {
  pname = "protobuf";

  version = "3.13.0.1";
  sha256 = "0vzxwisa8g3xgzcwa5b6cx6nyf41gkm71rxiisnnz1axz4q0hzqf";

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
