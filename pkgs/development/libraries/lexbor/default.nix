{
  lib
, stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  pname = "lexbor";
  version = "unstable-2021-12-20";

  src = fetchFromGitHub {
    repo = "lexbor";
    owner = "lexbor";
    rev = "44db846ef41d33e20557af985af12c82840003a3";
    sha256 = "sha256-B056Lkv2Nj5STGskW2vbph1KOkvg3f9d7ZAQsuE16uE=";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [] ++ lib.optionals stdenv.hostPlatform.isStatic [
    "-DLEXBOR_BUILD_TESTS=ON"
    "-DLEXBOR_BUILD_EXAMPLES=ON"
  ];

  env.NIX_CFLAGS_COMPILE = toString [
    # Needed with GCC 12
    "-Wno-error=address"
  ];

  meta = with lib; {
    description = "Lexbor is development of an open source HTML Renderer library";
    homepage = "https://lexbor.com/";
    license = licenses.asl20;
    maintainers = with maintainers; [ cafkafk ];
    platforms = platforms.all;
  };
}
