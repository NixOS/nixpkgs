{
  stdenv,
  lib,
  fetchFromGitHub,
  autoPatchelfHook,
  popt,
  libxcrypt-legacy,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wmic-bin";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "R-Vision";
    repo = "wmi-client";
    rev = finalAttrs.version;
    sha256 = "1w1mdbiwz37wzry1q38h8dyjaa6iggmsb9wcyhhlawwm1vj50w48";
  };

  buildInputs = [
    popt
    libxcrypt-legacy
  ];

  nativeBuildInputs = [ autoPatchelfHook ];

  dontConfigure = true;
  dontBuild = true;
  doInstallCheck = true;

  installPhase = ''
    runHook preInstall

    install -Dm755 bin/wmic_ubuntu_x64 $out/bin/wmic
    install -Dm644 -t $out/share/doc/wmic LICENSE README.md

    runHook postInstall
  '';

  installCheckPhase = ''
    runHook preInstallCheck

    $out/bin/wmic --help >/dev/null

    runHook postInstallCheck
  '';

  meta = {
    description = "WMI client for Linux (binary)";
    mainProgram = "wmic";
    homepage = "https://www.openvas.org";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ peterhoeg ];
    platforms = [ "x86_64-linux" ];
  };
})
