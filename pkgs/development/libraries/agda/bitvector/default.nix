{ stdenv, agda, fetchgit, AgdaStdlib }:

agda.mkDerivation (self: rec {
  version = "f1c173313f2a41d95a8dc6053f9365a24690e18d";
  name = "bitvector-${version}";

  src = fetchgit {
    url = "https://github.com/copumpkin/bitvector.git";
    rev = version;
    sha256 = "c39f55b709366f2c627d1a3a68d4b013c415b0e0f68ca6b69e387d07e2ce6d9a";
  };

  buildDepends = [ AgdaStdlib ];
  sourceDirectories = [ "Data" ];

  meta = {
    homepage = "https://github.com/copumpkin/bitvector";
    description = "Sequences of bits and common operations on them";
    license = stdenv.lib.licenses.bsd3;
    platforms = stdenv.lib.platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ fuuzetsu ];
  };
})
