{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  perl,
  systemd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "triggerhappy";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "wertarbyte";
    repo = "triggerhappy";
    rev = "release/${finalAttrs.version}";
    hash = "sha256-IE1rQywR2MPPcwFeF7JFwt0mVAANAdKWKvFg3jPEYT0=";
  };

  nativeBuildInputs = [
    pkg-config
    perl
  ];
  buildInputs = [ systemd ];

  makeFlags = [
    "PREFIX=$(out)"
    "BINDIR=$(out)/bin"
  ];

  postInstall = ''
    install -D -m 644 -t "$out/etc/triggerhappy/triggers.d" "triggerhappy.conf.examples"
  '';

  meta = {
    description = "Lightweight hotkey daemon";
    longDescription = ''
      Triggerhappy is a hotkey daemon developed with small and embedded systems in
      mind, e.g. linux based routers. It attaches to the input device files and
      interprets the event data received and executes scripts configured in its
      configuration.
    '';
    homepage = "https://github.com/wertarbyte/triggerhappy/";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ taha ];
  };
})
