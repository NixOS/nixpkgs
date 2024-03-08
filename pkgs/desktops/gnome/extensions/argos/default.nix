{ fetchFromGitHub, lib, stdenv }:

stdenv.mkDerivation rec {
  pname = "argos";
  version = "unstable-2023-09-26";

  src = fetchFromGitHub {
    owner = "p-e-w";
    repo = "argos";
    rev = "adfaa31e8c08f7b59e9492891a7e6f753c29b35e";  # https://github.com/p-e-w/argos/pull/150
    hash = "sha256-st8AeMRtkvM4M/Z70qopjw9Yx0t9l0DsUke4ClQtcBU=";
  };

  installPhase = ''
    mkdir -p "$out/share/gnome-shell/extensions"
    cp -a argos@pew.worldwidemann.com "$out/share/gnome-shell/extensions"
  '';

  passthru = {
    extensionUuid = "argos@pew.worldwidemann.com";
    extensionPortalSlug = "argos";
  };

  meta = with lib; {
    description = "Create GNOME Shell extensions in seconds";
    license = licenses.gpl3;
    maintainers = with maintainers; [ andersk ];
    homepage = "https://github.com/p-e-w/argos";
  };
}
