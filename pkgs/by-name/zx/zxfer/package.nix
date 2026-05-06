{
  lib,
  fetchFromGitHub,
  installShellFiles,
  makeWrapper,
  stdenvNoCC,

  coreutils,
  gawk,
  gnugrep,
  gnused,
  openssh,
  rsync,
  which,
  zfs,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "zxfer";
  version = "1.1.7";

  src = fetchFromGitHub {
    owner = "allanjude";
    repo = "zxfer";
    rev = "v${finalAttrs.version}";
    hash = "sha256-11SQJcD3GqPYBIgaycyKkc62/diVKPuuj2Or97j+NZY=";
  };

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
  ];

  # these may point to paths on remote systems, calculated at runtime, thus we cannot fix them
  # we can only set their initial values, and let them remain dynamic
  postPatch = ''
    substituteInPlace zxfer \
      --replace-fail 'LCAT=""'             'LCAT=${coreutils}/bin/cat' \
      --replace-fail 'LZFS=$( which zfs )' 'LZFS=${zfs}/bin/zfs'
  '';

  installPhase = ''
    runHook preInstall

    installManPage zxfer.1m zxfer.8
    install -Dm755 zxfer -t $out/bin/

    runHook postInstall
  '';

  postFixup = ''
    wrapProgram $out/bin/zxfer \
      --prefix PATH : ${
        lib.makeBinPath [
          coreutils
          gawk
          gnugrep
          gnused
          openssh
          rsync
          which
        ]
      }
  '';

  meta = {
    description = "Popular script for managing ZFS snapshot replication";
    homepage = "https://github.com/allanjude/zxfer";
    changelog = "https://github.com/allanjude/zxfer/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.bsd2;
    maintainers = [ ];
    mainProgram = "zxfer";
  };
})
