# Nix does not call the project's Makefile: buildGoModule builds and installs
# the binary itself, so everything else the Makefile installs ―the systemd user
# units and the manual page― is installed in postInstall.
{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "uxsm";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "heizeisaburou";
    repo = "uxsm";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SW+j06+kVSxv4hPiVToMm2w5NSeea9dhVGa9dDJn5jw=";
  };

  # Standard library only: no vendor directory to hash.
  vendorHash = null;

  subPackages = [ "cmd/uxsm" ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  # What the Makefile installs besides the binary.
  postInstall = ''
    for f in data/systemd/user/*.in; do
      unit=$out/lib/systemd/user/$(basename "$f" .in)
      install -Dm644 "$f" "$unit"
      substituteInPlace "$unit" --replace-quiet @BINDIR@ $out/bin
    done
    for f in data/man/*.1.in; do
      page=$out/share/man/man1/$(basename "$f" .in)
      install -Dm644 "$f" "$page"
      substituteInPlace "$page" \
        --replace-quiet @BINDIR@ $out/bin \
        --replace-quiet @VERSION@ "${finalAttrs.version}"
    done
  '';

  meta = {
    description = "X11 session manager for systemd --user, the X11 counterpart of uwsm";
    homepage = "https://github.com/heizeisaburou/uxsm";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ heizeisaburou ];
    mainProgram = "uxsm";
    platforms = lib.platforms.linux;
  };
})
