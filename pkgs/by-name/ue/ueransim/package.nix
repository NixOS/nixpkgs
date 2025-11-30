{
  lib,
  stdenv,
  cmake,
  pkg-config,
  fetchFromGitHub,
  lksctp-tools,
  iproute2,
  unstableGitUpdater,
  makeWrapper,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "ueransim";
  version = "3.2.6-unstable-2024-08-27";

  src = fetchFromGitHub {
    owner = "aligungr";
    repo = "ueransim";
    rev = "528061fe10389876da58d3bd15e8cba6d7c152a9";
    hash = "sha256-8OxJzEcpFT6e/nQw1VK9kBdw9ulXedCpUEaBxIAN9cA=";
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

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Open source 5G UE and RAN (gNodeB) implementation";
    homepage = "https://github.com/aligungr/UERANSIM";
    changelog = "https://github.com/aligungr/UERANSIM/releases";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ theobori ];
    license = lib.licenses.gpl3Only;
  };
})
