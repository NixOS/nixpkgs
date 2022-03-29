{ bash, fetchFromGitHub, lib, stdenvNoCC }:

stdenvNoCC.mkDerivation rec {
  pname = "WhiteSur-wallpapers";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-76oxSsjK5vuGgb1wQOEXNi/76e9yqHQoXxANqzrkbl8=";
  };

  nativeBuildInputs = [ bash ];

  installPhase = ''
    runHook preInstall

    export HOME=$(mktemp -d)
    bash install-wallpapers.sh
    mkdir -p $out
    mv $HOME/.local/share $out
    rm -rf $HOME

    runHook postInstall
  '';

  meta = with lib; {
    description = "WhiteSur wallpapers";
    homepage = "https://github.com/vinceliuice/WhiteSur-wallpapers";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ sei40kr ];
  };
}
