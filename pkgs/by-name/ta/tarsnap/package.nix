{
  lib,
  stdenv,
  fetchurl,
  openssl,
  zlib,
  e2fsprogs,
  bzip2,
  installShellFiles,
}:

let
  zshCompletion = fetchurl {
    url = "https://gist.githubusercontent.com/thoughtpolice/daa9431044883d3896f6/raw/282360677007db9739e5bf229873d3b231eb303a/tarsnap.zsh";
    sha256 = "0pawqwichzpz29rva7mh8lpx4zznnrh2rqyzzj6h7z98l0dxpair";
  };
in
stdenv.mkDerivation rec {
  pname = "tarsnap";
  version = "1.0.41";

  src = fetchurl {
    url = "https://www.tarsnap.com/download/tarsnap-autoconf-${version}.tgz";
    hash = "sha256-vr2+Hm6RIzdVvrQu8LStvv2Vc0VSWPAJ+zMVVseZs9A=";
  };

  configureFlags = [
    "--with-bash-completion-dir=${placeholder "out"}/share/bash-completion/completions"
    # required for cross builds
    "--host=${stdenv.hostPlatform.system}"
  ];

  makeFlags = [
    "AR=${stdenv.cc.targetPrefix}ar"
  ];

  postPatch = ''
    substituteInPlace Makefile.in \
      --replace-fail "command -p mv" "mv"
    substituteInPlace configure \
      --replace-fail "command -p getconf PATH" "echo $PATH"
  '';

  postInstall = ''
    # install third-party zsh completions (bash completions already available)
    installShellCompletion --cmd tarsnap \
      --zsh ${zshCompletion}
  '';

  nativeBuildInputs = [
    installShellFiles
  ];

  buildInputs = [
    openssl
    zlib
  ]
  ++ lib.optional stdenv.hostPlatform.isLinux e2fsprogs
  ++ lib.optional stdenv.hostPlatform.isDarwin bzip2;

  meta = {
    description = "Online backups for the truly paranoid";
    homepage = "http://www.tarsnap.com/";
    license = lib.licenses.unfree;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      thoughtpolice
      roconnor
    ];
    mainProgram = "tarsnap";
  };
}
