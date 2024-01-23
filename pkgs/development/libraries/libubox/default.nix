{ stdenv, lib, fetchgit, cmake, pkg-config, json_c, with_lua ? false, lua5_1, with_ustream_ssl ? false, ustream-ssl }:

stdenv.mkDerivation {
  pname = "libubox";
  version = "unstable-2023-11-28";

  src = fetchgit {
    url = "https://git.openwrt.org/project/libubox.git";
    rev = "e80dc00ee90c29ef56ae28f414b0e5bb361206e7";
    hash = "sha256-R4Yz4C63LQTNBKyNyiLMQHfc5KJBPFldP1trmtEBb9U=";
  };

  cmakeFlags = [ "-DBUILD_EXAMPLES=OFF" (if with_lua then "-DLUAPATH=${placeholder "out"}/lib/lua" else "-DBUILD_LUA=OFF") ];

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ json_c ] ++ lib.optional with_lua lua5_1 ++ lib.optional with_ustream_ssl ustream-ssl;

  postInstall = lib.optionalString with_ustream_ssl ''
    for fin in $(find ${ustream-ssl} -type f); do
      fout="''${fin/"${ustream-ssl}"/"''${out}"}"
      ln -s "$fin" "$fout"
    done
  '';

  meta = with lib; {
    description = "C utility functions for OpenWrt";
    homepage = "https://git.openwrt.org/?p=project/libubox.git;a=summary";
    license = licenses.isc;
    maintainers = with maintainers; [ fpletz mkg20001 ];
    mainProgram = "jshn";
    platforms = platforms.all;
  };
}
