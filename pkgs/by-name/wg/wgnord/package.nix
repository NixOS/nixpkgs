{
  coreutils,
  curl,
  fetchFromGitHub,
  gnugrep,
  gnused,
  iproute2,
  jq,
  lib,
  makeWrapper,
  stdenvNoCC,
  wireguard-tools,
}:

stdenvNoCC.mkDerivation rec {
  pname = "wgnord";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "phirecc";
    repo = "wgnord";
    rev = version;
    hash = "sha256-26cfYXtZVQ7kIRxY6oNGCqIjdw/hjwXhVKimVgolLgk=";
  };

  nativeBuildInputs = [ makeWrapper ];

  postPatch = ''
    substituteInPlace wgnord \
      --replace-fail '$conf_dir/countries.txt' "$out/share/countries.txt" \
      --replace-fail '$conf_dir/countries_iso31662.txt' "$out/share/countries_iso31662.txt"
  '';

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    install -Dm 755 wgnord -t $out/bin/
    install -Dm 644 countries.txt -t $out/share/
    install -Dm 644 countries_iso31662.txt -t $out/share/
    runHook postInstall
  '';

  postFixup = ''
    wrapProgram $out/bin/wgnord \
      --prefix PATH : ${
        lib.makeBinPath [
          coreutils
          curl
          gnugrep
          gnused
          iproute2
          jq
          wireguard-tools
        ]
      }
  '';

  meta = {
    description = "NordVPN Wireguard (NordLynx) client in POSIX shell";
    homepage = "https://github.com/phirecc/wgnord";
    changelog = "https://github.com/phirecc/wgnord/releases/tag/v${version}";
    maintainers = [ ];
    license = lib.licenses.mit;
    mainProgram = "wgnord";
    platforms = lib.platforms.linux;
  };
}
