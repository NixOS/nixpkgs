{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  alsa-lib,
  libX11,
  pcsclite,
  testers,
}:

let
  version = "4.19.0";
  buildNum = "4005";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "tlclient";
  version = "${version}-${buildNum}";

  src = fetchurl {
    url = "https://www.cendio.com/downloads/clients/tl-${finalAttrs.version}-client-linux-dynamic-x86_64.tar.gz";
    hash = "sha256-shlhu0m+TPgw3ndR70QdJ6Z0AyJdI/xmHJv+ZbFVokE=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [
    alsa-lib
    libX11
    pcsclite
  ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    rm etc/ssh_known_hosts
    rm --recursive lib/tlclient/lib
    substituteInPlace lib/tlclient/share/applications/thinlinc-client.desktop \
      --replace-fail "/opt/thinlinc/bin/" ""
    cp --recursive . $out
    cp --recursive $out/lib/tlclient/share $out/share
    install -D --mode=0644 $out/lib/tlclient/EULA.txt $out/share/licenses/tlclient/EULA.txt
    install -D --mode=0644 $out/lib/tlclient/open_source_licenses.txt $out/share/licenses/tlclient/open_source_licenses.txt

    runHook postInstall
  '';

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
    version = "${version} build ${buildNum}";
  };

  meta = {
    description = "Linux remote desktop client built on open source technology";
    license = {
      fullName = "Cendio end-user license agreement";
      url = "https://www.cendio.com/thinlinc/docs/legal/eula";
      free = false;
    };
    homepage = "https://www.cendio.com/";
    changelog = "https://www.cendio.com/thinlinc/docs/relnotes/${version}/";
    maintainers = with lib.maintainers; [
      felixalbrigtsen
      kyehn
    ];
    platforms = with lib.platforms; linux ++ darwin ++ windows;
    broken = !(stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isx86_64);
    mainProgram = "tlclient";
  };
})
