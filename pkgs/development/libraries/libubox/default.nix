{ stdenv, lib, fetchgit, cmake, pkg-config, json_c, with_lua ? false, lua5_1, with_ustream_ssl ? false, ustream-ssl }:

stdenv.mkDerivation {
  pname = "libubox";
  version = "unstable-2023-01-03${lib.optionalString with_ustream_ssl "-${ustream-ssl.ssl_implementation.pname}"}";

  src = fetchgit {
    url = "https://git.openwrt.org/project/libubox.git";
    rev = "eac92a4d5d82eb31e712157e7eb425af728b2c43";
    sha256 = "0w6mmwmd3ljhkqfk0qswq28dp63k30s3brlgf8lyi7vj7mrhvn3c";
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
