{ buildPecl, lib, pcre', fetchpatch }:

buildPecl {
  pname = "protobuf";

  version = "3.14.0";
  sha256 = "1ldc4s28hq61cfg8l4c06pgicj0ng7k37f28a0dnnbs7xkr7cibd";

  buildInputs = [ pcre' ];

  patches = [
    # TODO: remove with next update
    (fetchpatch {
      url = "https://github.com/protocolbuffers/protobuf/commit/823f351448f7c432bed40b89ee3309e0a94c1855.patch";
      sha256 = "sha256-ozHtO8s9zvmh/+wBEge3Yn3n0pbpR3dAojJcuAg/G3s=";
      stripLen = 4;
      includes = [
        "array.c"
        "def.c"
        "map.c"
        "message.c"
        "protobuf.h"
        "wkt.inc"
      ];
    })
  ];

  meta = with lib; {
    description = ''
      Google's language-neutral, platform-neutral, extensible mechanism for serializing structured data.
    '';
    license = licenses.bsd3;
    homepage = "https://developers.google.com/protocol-buffers/";
    maintainers = teams.php.members;
  };
}
