{
  stdenv,
  lib,
  fetchFromGitHub,
  makeWrapper,
  installShellFiles,
  dmidecode,
  ethtool,
  pciutils,
  multipath-tools,
  iproute2,
  sysvinit,
}:
let
  binPath = [
    iproute2
    dmidecode
    ethtool
    pciutils
    multipath-tools
    iproute2
    sysvinit
  ];
in

stdenv.mkDerivation rec {
  pname = "xsos";
  version = "0.7.33";

  src = fetchFromGitHub {
    owner = "ryran";
    repo = "xsos";
    rev = "v${version}";
    sha256 = "sha256-VEOY422/+4veMlN9HOtPB/THDiFLNnRfbUJpKjc/cqE=";
  };

  nativeBuildInputs = [
    makeWrapper
    installShellFiles
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp -a xsos $out/bin
    wrapProgram "$out/bin/xsos" --prefix PATH : ${lib.makeBinPath binPath}
    installShellCompletion --bash --name xsos.bash xsos-bash-completion.bash
  '';

<<<<<<< HEAD
  meta = {
    description = "Summarize system info from sosreports";
    mainProgram = "xsos";
    homepage = "https://github.com/ryran/xsos";
    license = lib.licenses.gpl3;
=======
  meta = with lib; {
    description = "Summarize system info from sosreports";
    mainProgram = "xsos";
    homepage = "https://github.com/ryran/xsos";
    license = licenses.gpl3;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    platforms = [
      "i686-linux"
      "x86_64-linux"
    ];
<<<<<<< HEAD
    maintainers = [ lib.maintainers.nixinator ];
=======
    maintainers = [ maintainers.nixinator ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
