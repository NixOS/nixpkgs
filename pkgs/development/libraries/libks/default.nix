{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, cmake
, pkg-config
, libuuid
, openssl
, libossp_uuid
}:

stdenv.mkDerivation rec {
  pname = "libks";
  version = "1.8.2";

  src = fetchFromGitHub {
    owner = "signalwire";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-TJ3q97K3m3zYGB1D5lLVyrh61L3vtnP5I64lP/DYzW4=";
  };

  patches = [
    (fetchpatch {
      url = "https://raw.githubusercontent.com/openwrt/telephony/5ced7ea4fc9bd746273d564bf3c102f253d2182e/libs/libks/patches/01-find-libm.patch";
      sha256 = "1hyrsdxg69d08qzvf3mbrx2363lw52jcybw8i3ynzqcl228gcg8a";
    })
  ];

  dontUseCmakeBuildDir = true;

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [ openssl ]
    ++ lib.optional stdenv.isLinux libuuid
    ++ lib.optional stdenv.isDarwin libossp_uuid;

  meta = with lib; {
    description = "Foundational support for signalwire C products";
    homepage = "https://github.com/signalwire/libks";
    maintainers = with lib.maintainers; [ misuzu ];
    platforms = platforms.unix;
    license = licenses.mit;
  };
}
