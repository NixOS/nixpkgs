{
  stdenv,
  lib,
  fetchgit,
  cmake,
  pkg-config,
  json_c,
  with_lua ? false,
  lua5_1,
  with_ustream_ssl ? false,
  ustream-ssl,
}:

stdenv.mkDerivation {
  pname = "libubox";
  version = "0-unstable-2025-07-23";

  src = fetchgit {
    url = "https://git.openwrt.org/project/libubox.git";
    rev = "49056d178f42da98048a5d4c23f83a6f6bc6dd80";
    hash = "sha256-sk5r18M0hJ+8CrC2G/rb+XqUmUGer2VBrVbuReHj1dM=";
  };

  cmakeFlags = [
    "-DBUILD_EXAMPLES=OFF"
    (if with_lua then "-DLUAPATH=${placeholder "out"}/lib/lua" else "-DBUILD_LUA=OFF")
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [
    json_c
  ]
  ++ lib.optional with_lua lua5_1
  ++ lib.optional with_ustream_ssl ustream-ssl;

  postInstall = lib.optionalString with_ustream_ssl ''
    for fin in $(find ${ustream-ssl} -type f); do
      fout="''${fin/"${ustream-ssl}"/"''${out}"}"
      ln -s "$fin" "$fout"
    done
  '';

  env.NIX_CFLAGS_COMPILE = toString (
    lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64) [
      "-Wno-error=gnu-folding-constant"
    ]
  );

  meta = with lib; {
    description = "C utility functions for OpenWrt";
    homepage = "https://git.openwrt.org/?p=project/libubox.git;a=summary";
    license = licenses.isc;
    maintainers = with maintainers; [
      fpletz
      mkg20001
      dvn0
    ];
    mainProgram = "jshn";
    platforms = platforms.all;
  };
}
