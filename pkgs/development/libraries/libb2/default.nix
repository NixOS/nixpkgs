{stdenv, fetchurl}:
with stdenv; with lib;
mkDerivation rec {
  name = "libb2-${meta.version}";

  src = fetchurl {
    url = "https://blake2.net/${name}.tar.gz";
    sha256 = "7829c7309347650239c76af7f15d9391af2587b38f0a65c250104a2efef99051";
  };

  configureFlags = [ "--enable-fat=yes" ];

  meta = {
    version = "0.97";
    description = "The BLAKE2 family of cryptographic hash functions";
    platforms = platforms.all;
    maintainers = with maintainers; [ dfoxfranke ];
    license = licenses.cc0;
  };
}
