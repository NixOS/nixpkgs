{stdenv, fetchurl}:

let
  version="0.5.0";  
in
stdenv.mkDerivation {
  name = "sodium-${version}";

  src = fetchurl {
    url = "https://github.com/jedisct1/libsodium/releases/download/0.5.0/libsodium-${version}.tar.gz";
    sha256="1w7rrnsvhhzhywrr3nhlhppv4kqzdszz3dwy8jrsv8lrj5hs181w";
  };

  doCheck = true;

  meta = {
    description = "Sodium is a portable, cross-compilable fork of NaCl";
    longDescription = ''
      NaCl (pronounced "salt") is a new easy-to-use high-speed software library for network communication, encryption, decryption, signatures, etc.

      NaCl's goal is to provide all of the core operations needed to build higher-level cryptographic tools.

      Sodium is a portable, cross-compilable, installable, packageable fork of NaCl (based on the latest released upstream version nacl-20110221), with a compatible API.

      The design choices, particularly in regard to the Curve25519 Diffie-Hellman function, emphasize security (whereas NIST curves emphasize "performance" at the cost of security), and "magic constants" in NaCl/Sodium have clear rationales.

      The same cannot be said of NIST curves, where the specific origins of certain constants are not described by the standards.

      And despite the emphasis on higher security, primitives are faster across-the-board than most implementations of the NIST standards.
    '';
    homepage = https://github.com/jedisct1/libsodium;
    license = stdenv.lib.licenses.mit;
    maintainers = with stdenv.lib.maintainers; [ raskin emery ];
    platforms = stdenv.lib.platforms.all;
  };
}
