{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  openssh,
  socat,
  gawk,
  cloud-utils,
  cdrtools,
  qemu,
  qemu-utils,
  coreutils,
  getopt,
  makeWrapper,
}:

stdenvNoCC.mkDerivation {
  pname = "vmctl";
  version = "v0.99-unstable-2024-05-14";

  src = fetchFromGitHub {
    owner = "SamsungDS";
    repo = "vmctl";
    rev = "5b6b7084b8cba06b474c0e020df965237f2c832c";
    hash = "sha256-yDgaY2RJXBjWkMSQb4JaJzMGLFzowfOGixSRzzv2iIk=";
  };

  dontBuild = true;

  postPatch = ''
    substituteInPlace vmctl \
      --replace 'BASEDIR="$(dirname "$(readlink -f "''${BASH_SOURCE[0]}")")"' 'BASEDIR="${placeholder "out"}"'
  '';

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    install -Dm555 vmctl -t "$out/bin"
    wrapProgram "$out/bin/vmctl" \
      --set PATH "${
        lib.makeBinPath [
          openssh
          socat
          gawk
          cloud-utils
          cdrtools
          qemu
          qemu-utils
          coreutils
          getopt
        ]
      }"
    cp -r {cmd,common,contrib,lib} $out

    runHook postInstall
  '';

  meta = {
    description = "Command line tool focused on NVMe testing in QEMU";
    homepage = "https://github.com/SamsungDS/vmctl";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ panky ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
}
