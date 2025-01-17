{ lib
, stdenv
, fetchFromGitiles
, libuuid
, makeWrapper
, flashrom
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vpd";
  version = "R117-15572.B";

  src = fetchFromGitiles {
    url = "https://chromium.googlesource.com/chromiumos/platform/vpd/";
    rev = "0827891b4ea45375ca3d9fd395d3161bbd65144e";
    hash = "sha256-7840GSQU7g0Mtq96avpJ2QM60xF9QyYmSLgRhDTfjk8=";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ libuuid ];

  buildFlags = [ "VERSION=release-${finalAttrs.version}" ];

  installPhase = ''
    runHook preInstall

    install -Dm0755 --target-directory=$out/bin vpd
    wrapProgram $out/bin/vpd --prefix PATH : ${lib.makeBinPath [ flashrom ]}

    runHook postInstall
  '';

  meta = with lib; {
    description = "ChromiumOS Vital Product Data tooling for firmware images";
    homepage = "https://chromium.googlesource.com/chromiumos/platform/vpd/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ jmbaur ];
    mainProgram = "vpd";
    platforms = platforms.linux;
  };
})
