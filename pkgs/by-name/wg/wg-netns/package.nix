{
  lib,
  fetchFromGitHub,
  python3,
  iproute2,
  wireguard-tools,
  socat,
  getent,
}:
python3.pkgs.buildPythonApplication rec {
  pname = "wg-netns";
  version = "2.3.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dadevel";
    repo = "wg-netns";
    rev = "v${version}";
    hash = "sha256-N5MY7EoskrOR3eMrt8Y2GcIJhIvyAjQyhttT/5bWhEg=";
  };

  build-system = [
    python3.pkgs.poetry-core
  ];

  dependencies = [
    python3.pkgs.pyyaml
    iproute2
    wireguard-tools
    socat
    getent
  ];

  postInstall = ''
    install -Dm600 extras/wg-netns@.service -t $out/lib/systemd/system
    substituteInPlace $out/lib/systemd/system/wg-netns@.service \
      --replace "ExecStart=wg-netns" "ExecStart=$out/bin/wg-netns"
    substituteInPlace $out/lib/systemd/system/wg-netns@.service \
      --replace "ExecStop=wg-netns" "ExecStop=$out/bin/wg-netns"

    install -Dm755 extras/netns-publish.sh -t $out/bin
    wrapProgram $out/bin/netns-publish.sh --prefix PATH : ${lib.makeBinPath [ socat ]}
  '';

  meta = {
    description = "WireGuard with Linux Network Namespaces";

    longDescription = ''
      With wg-netns you can setup Wireguard tunnels in network namespaces,
      which then can be used by containers, systemd services etc.
      Works similar to wg-quick and implements the steps described at wireguard.com/netns.
    '';
    platforms = lib.platforms.linux;
    homepage = "https://github.com/dadevel/wg-netns";
    license = [ lib.licenses.mit ];
    maintainers = [ lib.maintainers.claes ];
  };
}
