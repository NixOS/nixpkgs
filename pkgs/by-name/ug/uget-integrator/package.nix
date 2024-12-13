{
  lib,
  stdenv,
  fetchFromGitHub,
  uget,
  python3Packages,
}:

stdenv.mkDerivation rec {
  pname = "uget-integrator";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "ugetdm";
    repo = "uget-integrator";
    rev = "v${version}";
    sha256 = "0bfqwbpprxp5sy49p2hqcjdfj7zamnp2hhcnnyccffkn7pghx8pp";
  };

  nativeBuildInputs = [ python3Packages.wrapPython ];

  buildInputs = [
    uget
    python3Packages.python
  ];

  installPhase = ''
    for f in conf/com.ugetdm.{chrome,firefox}.json; do
      substituteInPlace $f --replace "/usr" "$out"
    done

    install -D -t $out/bin                                   bin/uget-integrator
    install -D -t $out/etc/opt/chrome/native-messaging-hosts conf/com.ugetdm.chrome.json
    install -D -t $out/etc/chromium/native-messaging-hosts   conf/com.ugetdm.chrome.json
    install -D -t $out/etc/opera/native-messaging-hosts      conf/com.ugetdm.chrome.json
    install -D -t $out/lib/mozilla/native-messaging-hosts    conf/com.ugetdm.firefox.json

    wrapPythonPrograms
  '';

  meta = with lib; {
    description = "Native messaging host to integrate uGet Download Manager with web browsers";
    mainProgram = "uget-integrator";
    homepage = "https://github.com/ugetdm/uget-integrator";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.romildo ];
  };
}
