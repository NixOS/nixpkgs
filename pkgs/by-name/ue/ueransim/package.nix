{
  lib,
  stdenv,
  cmake,
  pkg-config,
  fetchFromGitHub,
  lksctp-tools,
  iproute2,
  nix-update-script,
  makeWrapper,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "ueransim";
  version = "3.2.8";

  src = fetchFromGitHub {
    owner = "aligungr";
    repo = "ueransim";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dnFGPEgnmbx+ehfeas1Imv8G7s8snd7P2h70E3PtmuY=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    makeWrapper
  ];

  buildInputs = [ lksctp-tools ];

  postPatch = ''
    substituteInPlace tools/nr-binder \
      --replace-fail "./libdevbnd.so" "$out/lib/libdevbnd.so"
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,lib}

    chmod +x ../tools/nr-binder
    cp ../tools/nr-binder $out/bin

    for app in nr-gnb nr-ue nr-cli; do
      cp $app $out/bin
      wrapProgram "$out/bin/$app" \
        --prefix PATH : ${lib.makeBinPath [ iproute2 ]}
    done

    cp libdevbnd.so $out/lib

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Open source 5G UE and RAN (gNodeB) implementation";
    homepage = "https://github.com/aligungr/UERANSIM";
    changelog = "https://github.com/aligungr/UERANSIM/releases";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ theobori ];
    license = lib.licenses.gpl3Only;
  };
})
