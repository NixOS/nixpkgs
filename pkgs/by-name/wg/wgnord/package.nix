{
  bash,
  coreutils,
  curl,
  gawk,
  fetchFromGitHub,
  gnugrep,
  gnused,
  iproute2,
  jq,
  lib,
  resholve,
  unstableGitUpdater,
  wireguard-tools,
}:

resholve.mkDerivation (finalAttrs: {
  pname = "wgnord";
  version = "0.2.2-unstable-2026-11-01";

  src = fetchFromGitHub {
    owner = "phirecc";
    repo = "wgnord";
    rev = "40dd4efea71b1843e8abe9f3b6931dfe1253f7a7";
    hash = "sha256-uPNatCT5/anyRPljTzGombWsA2iY54Hjd3TpHwQTBX8=";
  };

  postPatch = ''
    sed -i 's|^alias query=.*|query() { curl -s -H "User-Agent: NordApp Linux $version $kernel-generic" "$@"; }|' wgnord
    substituteInPlace wgnord \
      --replace-fail '$conf_dir/countries.txt' "$out/share/countries.txt" \
      --replace-fail '$conf_dir/countries_iso31662.txt' "$out/share/countries_iso31662.txt" \
      --replace-fail '$conf_dir/template.conf' "$out/share/template.conf"
  '';

  dontBuild = true;

  installPhase = ''
    install -Dm 755 wgnord -t $out/bin/
    install -Dm 644 countries.txt -t $out/share/
    install -Dm 644 countries_iso31662.txt -t $out/share/
    install -Dm 644 template.conf -t $out/share/
  '';

  solutions.default = {
    scripts = [ "bin/wgnord" ];
    interpreter = "${bash}/bin/sh";
    inputs = [
      coreutils
      curl
      gawk
      gnugrep
      gnused
      iproute2
      jq
      wireguard-tools
    ];
    fix.aliases = true; # curl command in an alias
    execer = [
      "cannot:${iproute2}/bin/ip"
      "cannot:${wireguard-tools}/bin/wg-quick"
    ];
  };

  # Upstream bumps the NordApp version sent as User-Agent without tagging
  # releases. Outdated versions get "DEPRECATED" instead of a private key.
  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "NordVPN Wireguard (NordLynx) client in POSIX shell";
    homepage = "https://github.com/phirecc/wgnord";
    maintainers = with lib.maintainers; [ novalkun ];
    license = lib.licenses.mit;
    mainProgram = "wgnord";
    platforms = lib.platforms.linux;
  };
})
