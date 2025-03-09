{
  lib,
  stdenv,
  fetchFromGitHub,
  fixDarwinDylibNames,
}:
let
  libExt = stdenv.hostPlatform.extensions.sharedLibrary;
in
stdenv.mkDerivation rec {
  pname = "whereami";
  version = "unstable-2022-02-18";

  src = fetchFromGitHub {
    owner = "gpakosz";
    repo = pname;
    rev = "ba364cd54fd431c76c045393b6522b4bff547f50";
    sha256 = "XhRqW0wdXzlmyBf1cjqtQvztuyV4buxVl19Q0uyEOhk=";
  };

  nativeBuildInputs = lib.optional stdenv.hostPlatform.isDarwin fixDarwinDylibNames;

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isClang "-Wno-error=strict-prototypes";

  makeFlags = [
    "-C_gnu-make"
    "build-library"
    "binsubdir=platform"
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib $out/include
    cp bin/platform/library${libExt} $out/lib/libwhereami${libExt}
    cp src/whereami.h $out/include/whereami.h

    runHook postInstall
  '';

  meta = with lib; {
    description = "Locate the current executable and running module/library";
    homepage = "https://github.com/gpakosz/whereami";
    license = with licenses; [
      mit
      wtfpl
    ];
    maintainers = with maintainers; [ emilytrau ];
    platforms = platforms.all;
  };
}
