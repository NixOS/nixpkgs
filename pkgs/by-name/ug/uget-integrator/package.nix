{
  lib,
  stdenv,
  fetchFromGitHub,
  uget,
  python3Packages,
  installShellFiles,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "uget-integrator";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "ugetdm";
    repo = "uget-integrator";
    rev = "v${finalAttrs.version}";
    hash = "sha256-96IO3z12OseYt5ZBKK6t6h/pmmQYipuI1+X2fO/i2C0=";
  };

  nativeBuildInputs = [
    installShellFiles
    python3Packages.wrapPython
  ];

  buildInputs = [
    uget
    python3Packages.python
  ];

  installPhase = ''
    for f in conf/com.ugetdm.{chrome,firefox}.json; do
      substituteInPlace $f --replace "/usr" "$out"
    done

    installBin bin/uget-integrator
    install -D -t $out/etc/opt/chrome/native-messaging-hosts conf/com.ugetdm.chrome.json
    install -D -t $out/etc/chromium/native-messaging-hosts   conf/com.ugetdm.chrome.json
    install -D -t $out/etc/opera/native-messaging-hosts      conf/com.ugetdm.chrome.json
    install -D -t $out/lib/mozilla/native-messaging-hosts    conf/com.ugetdm.firefox.json

    wrapPythonPrograms
  '';

  meta = {
    description = "Native messaging host to integrate uGet Download Manager with web browsers";
    mainProgram = "uget-integrator";
    homepage = "https://github.com/ugetdm/uget-integrator";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.romildo ];
  };
})
