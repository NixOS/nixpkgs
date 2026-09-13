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
  wireguard-tools,
}:

resholve.mkDerivation (finalAttrs: {
  pname = "wgnord";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "phirecc";
    repo = "wgnord";
    rev = finalAttrs.version;
    hash = "sha256-K7O3SI24bkaLuEF+7FmbXUx7H0gPKsLttEmSCc3PT2c=";
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

  meta = {
    description = "NordVPN Wireguard (NordLynx) client in POSIX shell";
    homepage = "https://github.com/phirecc/wgnord";
    maintainers = [ ];
    license = lib.licenses.mit;
    mainProgram = "wgnord";
    platforms = lib.platforms.linux;
  };
})
