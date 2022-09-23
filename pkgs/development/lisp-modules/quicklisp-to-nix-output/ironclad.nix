/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "ironclad";
  version = "v0.56";

  parasites = [ "ironclad/aead/eax" "ironclad/aead/etm" "ironclad/aead/gcm" "ironclad/aeads" "ironclad/cipher/aes" "ironclad/cipher/arcfour" "ironclad/cipher/aria" "ironclad/cipher/blowfish" "ironclad/cipher/camellia" "ironclad/cipher/cast5" "ironclad/cipher/chacha" "ironclad/cipher/des" "ironclad/cipher/idea" "ironclad/cipher/kalyna" "ironclad/cipher/keystream" "ironclad/cipher/kuznyechik" "ironclad/cipher/misty1" "ironclad/cipher/rc2" "ironclad/cipher/rc5" "ironclad/cipher/rc6" "ironclad/cipher/salsa20" "ironclad/cipher/seed" "ironclad/cipher/serpent" "ironclad/cipher/sm4" "ironclad/cipher/sosemanuk" "ironclad/cipher/square" "ironclad/cipher/tea" "ironclad/cipher/threefish" "ironclad/cipher/twofish" "ironclad/cipher/xchacha" "ironclad/cipher/xor" "ironclad/cipher/xsalsa20" "ironclad/cipher/xtea" "ironclad/ciphers" "ironclad/core" "ironclad/digest/adler32" "ironclad/digest/blake2" "ironclad/digest/blake2s" "ironclad/digest/crc24" "ironclad/digest/crc32" "ironclad/digest/groestl" "ironclad/digest/jh" "ironclad/digest/kupyna" "ironclad/digest/md2" "ironclad/digest/md4" "ironclad/digest/md5" "ironclad/digest/ripemd-128" "ironclad/digest/ripemd-160" "ironclad/digest/sha1" "ironclad/digest/sha256" "ironclad/digest/sha3" "ironclad/digest/sha512" "ironclad/digest/skein" "ironclad/digest/sm3" "ironclad/digest/streebog" "ironclad/digest/tiger" "ironclad/digest/tree-hash" "ironclad/digest/whirlpool" "ironclad/digests" "ironclad/kdf/argon2" "ironclad/kdf/bcrypt" "ironclad/kdf/hmac" "ironclad/kdf/password-hash" "ironclad/kdf/pkcs5" "ironclad/kdf/scrypt" "ironclad/kdfs" "ironclad/mac/blake2-mac" "ironclad/mac/blake2s-mac" "ironclad/mac/cmac" "ironclad/mac/gmac" "ironclad/mac/hmac" "ironclad/mac/poly1305" "ironclad/mac/siphash" "ironclad/mac/skein-mac" "ironclad/macs" "ironclad/prng/fortuna" "ironclad/prngs" "ironclad/public-key/curve25519" "ironclad/public-key/curve448" "ironclad/public-key/dsa" "ironclad/public-key/ed25519" "ironclad/public-key/ed448" "ironclad/public-key/elgamal" "ironclad/public-key/rsa" "ironclad/public-key/secp256k1" "ironclad/public-key/secp256r1" "ironclad/public-key/secp384r1" "ironclad/public-key/secp521r1" "ironclad/public-keys" "ironclad/tests" ];

  description = "System lacks description";

  deps = [ args."alexandria" args."bordeaux-threads" args."rt" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/ironclad/2021-10-20/ironclad-v0.56.tgz";
    sha256 = "06jya7y8xlwak84akhp4qg9x6nyjrnnzqmzdigxc5a3c77mk3p6k";
  };

  packageName = "ironclad";

  asdFilesToKeep = ["ironclad.asd"];
  overrides = x: x;
}
/* (SYSTEM ironclad DESCRIPTION System lacks description SHA256
    06jya7y8xlwak84akhp4qg9x6nyjrnnzqmzdigxc5a3c77mk3p6k URL
    http://beta.quicklisp.org/archive/ironclad/2021-10-20/ironclad-v0.56.tgz
    MD5 3ea7bf7271864fd960d7e06a4e5aa9b7 NAME ironclad FILENAME ironclad DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME bordeaux-threads FILENAME bordeaux-threads) (NAME rt FILENAME rt))
    DEPENDENCIES (alexandria bordeaux-threads rt) VERSION v0.56 SIBLINGS
    (ironclad-text) PARASITES
    (ironclad/aead/eax ironclad/aead/etm ironclad/aead/gcm ironclad/aeads
     ironclad/cipher/aes ironclad/cipher/arcfour ironclad/cipher/aria
     ironclad/cipher/blowfish ironclad/cipher/camellia ironclad/cipher/cast5
     ironclad/cipher/chacha ironclad/cipher/des ironclad/cipher/idea
     ironclad/cipher/kalyna ironclad/cipher/keystream
     ironclad/cipher/kuznyechik ironclad/cipher/misty1 ironclad/cipher/rc2
     ironclad/cipher/rc5 ironclad/cipher/rc6 ironclad/cipher/salsa20
     ironclad/cipher/seed ironclad/cipher/serpent ironclad/cipher/sm4
     ironclad/cipher/sosemanuk ironclad/cipher/square ironclad/cipher/tea
     ironclad/cipher/threefish ironclad/cipher/twofish ironclad/cipher/xchacha
     ironclad/cipher/xor ironclad/cipher/xsalsa20 ironclad/cipher/xtea
     ironclad/ciphers ironclad/core ironclad/digest/adler32
     ironclad/digest/blake2 ironclad/digest/blake2s ironclad/digest/crc24
     ironclad/digest/crc32 ironclad/digest/groestl ironclad/digest/jh
     ironclad/digest/kupyna ironclad/digest/md2 ironclad/digest/md4
     ironclad/digest/md5 ironclad/digest/ripemd-128 ironclad/digest/ripemd-160
     ironclad/digest/sha1 ironclad/digest/sha256 ironclad/digest/sha3
     ironclad/digest/sha512 ironclad/digest/skein ironclad/digest/sm3
     ironclad/digest/streebog ironclad/digest/tiger ironclad/digest/tree-hash
     ironclad/digest/whirlpool ironclad/digests ironclad/kdf/argon2
     ironclad/kdf/bcrypt ironclad/kdf/hmac ironclad/kdf/password-hash
     ironclad/kdf/pkcs5 ironclad/kdf/scrypt ironclad/kdfs
     ironclad/mac/blake2-mac ironclad/mac/blake2s-mac ironclad/mac/cmac
     ironclad/mac/gmac ironclad/mac/hmac ironclad/mac/poly1305
     ironclad/mac/siphash ironclad/mac/skein-mac ironclad/macs
     ironclad/prng/fortuna ironclad/prngs ironclad/public-key/curve25519
     ironclad/public-key/curve448 ironclad/public-key/dsa
     ironclad/public-key/ed25519 ironclad/public-key/ed448
     ironclad/public-key/elgamal ironclad/public-key/rsa
     ironclad/public-key/secp256k1 ironclad/public-key/secp256r1
     ironclad/public-key/secp384r1 ironclad/public-key/secp521r1
     ironclad/public-keys ironclad/tests)) */
