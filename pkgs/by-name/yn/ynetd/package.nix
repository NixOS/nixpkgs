{
  lib,
  stdenv,
  fetchurl,
  callPackage,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "ynetd";
  version = "2024.02.17";

  src = fetchurl {
    url = "https://yx7.cc/code/ynetd/ynetd-2024.02.17.tar.xz";
    hash = "sha256-7gioQ0r0LlUftIWKRwTqeZQl0GtskcRKaEE5z6A0S24=";
  };

  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace Makefile --replace-fail "-Wl,-z,relro,-z,now" ""
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 ynetd $out/bin/ynetd
    runHook postInstall
  '';

  # ctf-ynetd releases are based on the last stable ynetd version
  # these should be kept in sync when possible
  passthru.hardened = callPackage ./hardened.nix { };

  meta = {
    description = "Small server for binding programs to TCP ports";
    homepage = "https://yx7.cc/code/";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.haylin ];
    mainProgram = "ynetd";
  };
})
