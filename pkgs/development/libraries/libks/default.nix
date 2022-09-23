{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, cmake
, pkg-config
, libuuid
, openssl
}:

stdenv.mkDerivation rec {
  pname = "libks";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "signalwire";
    repo = pname;
    rev = "v${version}";
    sha256 = "1wvl8kzi1fx7pg58r5x1lw4gwkvrkljqajsn72yq6sbsd3iqn8wr";
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

  buildInputs = [
    libuuid
    openssl
  ];

  meta = with lib; {
    description = "Foundational support for signalwire C products";
    homepage = "https://github.com/signalwire/libks";
    maintainers = with lib.maintainers; [ misuzu ];
    platforms = platforms.linux;
    license = licenses.mit;
  };
}
