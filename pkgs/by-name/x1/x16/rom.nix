{ lib
, stdenv
, fetchFromGitHub
, cc65
, lzsa
, python3
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "x16-rom";
  version = "47";

  src = fetchFromGitHub {
    owner = "X16Community";
    repo = "x16-rom";
    rev = "r${finalAttrs.version}";
    hash = "sha256-+NvuCW8CIj5cnrGh+VQOExhAeXMElqdl9DVJjjGhNPk=";
  };

  nativeBuildInputs = [
    cc65
    lzsa
    python3
  ];

  postPatch = ''
    patchShebangs findsymbols scripts/
    substituteInPlace Makefile \
    --replace '/bin/echo' 'echo'
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
  };

  meta = {
    homepage = "https://github.com/X16Community/x16-rom";
    description = "ROM file for CommanderX16 8-bit computer";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ AndersonTorres ];
    inherit (cc65.meta) platforms;
    broken = stdenv.isDarwin && stdenv.isAarch64;
  };
})
