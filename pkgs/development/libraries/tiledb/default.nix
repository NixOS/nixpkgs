{ pkgs ? import ./pkgs.nix }:

with pkgs;

  stdenv.mkDerivation rec {
    name = "tiledb";
    version = "1.5.1";

    src = pkgs.fetchFromGitHub {
      owner = "TileDB-Inc";
      repo = "TileDB";
      rev = "7236bb29f2aa1ac4de489f0791e9265cb257184d";
      sha256 = "sha256:0ky0dcv1w1jn1cjn3819aq9xyd2wg80aagf2flxmd916flgr9zjl";
  };

  makeTarget = "tiledb";
  outputs = ["py" "out"];

  nativeBuildInputs = [ doxygen cmake zlib lz4 bzip2 zstd spdlog tbb openssl];
 
  buildInputs = with pkgs; [ boost libpqxx catch python];

 
  cmakeFlags = [
  "-DCATCH_INCLUDE_DIR=${catch}/include/catch"
  "-DTILEDB_SUPERBUILD=OFF"
  ];
  
   meta = with stdenv.lib; {
  };

}
