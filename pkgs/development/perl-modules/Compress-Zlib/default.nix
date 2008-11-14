{fetchurl, perl}:

import ../generic perl {
  name = "Compress-Zlib-1.41";
  src = fetchurl {
    url = http://nixos.org/tarballs/Compress-Zlib-1.41.tar.gz;
    md5 = "ac135b84a03e814734496777cf5e5722";
  };
}
