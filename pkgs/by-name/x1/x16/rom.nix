{
  lib,
  stdenv,
  fetchFromGitHub,
  cc65,
  lzsa,
  python3,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "x16-rom";
  version = "48";

  src = fetchFromGitHub {
    owner = "X16Community";
    repo = "x16-rom";
    rev = "r${finalAttrs.version}";
    hash = "sha256-MXt839wpPdGVFgf1CAqfmWEP2Ws+5uUFOI14vAdUTvk=";
  };

  nativeBuildInputs = [
    cc65
    lzsa
    python3
  ];

  postPatch = ''
    patchShebangs findsymbols scripts/
    substituteInPlace Makefile \
      --replace-fail '/bin/echo' 'echo'
  '';

  dontConfigure = true;

  makeFlags = [ "PRERELEASE_VERSION=${finalAttrs.version}" ];

  installPhase = ''
    runHook preInstall

    install -Dm 444 -t $out/share/x16-rom/ build/x16/rom.bin
    install -Dm 444 -t $out/share/doc/x16-rom/ README.md

    runHook postInstall
  '';

  passthru = {
    # upstream project recommends emulator and rom to be synchronized; passing
    # through the version is useful to ensure this
    inherit (finalAttrs) version;
    updateScript = nix-update-script { };
  };

  meta = {
    homepage = "https://github.com/X16Community/x16-rom";
    description = "ROM file for CommanderX16 8-bit computer";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ pluiedev ];
    inherit (cc65.meta) platforms;
    broken = stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64;
  };
})
