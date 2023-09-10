{ stdenv, lib, fetchgit, cmake, pkg-config, json_c, with_lua ? false, lua5_1, with_ustream_ssl ? false, ustream-ssl }:

stdenv.mkDerivation {
  pname = "libubox";
  version = "unstable-2023-05-23";

  src = fetchgit {
    url = "https://git.openwrt.org/project/libubox.git";
    rev = "75a3b870cace1171faf57bd55e5a9a2f1564f757";
    hash = "sha256-QhJ09i7IWP6rbxrYuhisVsCr82Ou/JAZMEdkaLhZp1o=";
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
    maintainers = with maintainers; [ fpletz ];
    mainProgram = "jshn";
    platforms = platforms.all;
  };
}
