{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "jansson";
  version = "2.14";

  src = fetchFromGitHub {
    owner = "akheron";
    repo = "jansson";
    rev = "v${version}";
    sha256 = "sha256-FQgy2+g3AyRVJeniqPQj0KNeHgPdza2pmEIXqSyYry4=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    # networkmanager relies on libjansson.so:
    #   https://github.com/NixOS/nixpkgs/pull/176302#issuecomment-1150239453
    "-DJANSSON_BUILD_SHARED_LIBS=${if stdenv.hostPlatform.isStatic then "OFF" else "ON"}"
  ];

  meta = with lib; {
    homepage = "https://github.com/akheron/jansson";
    description = "C library for encoding, decoding and manipulating JSON data";
    changelog = "https://github.com/akheron/jansson/raw/v${version}/CHANGES";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [ ];
  };
}
