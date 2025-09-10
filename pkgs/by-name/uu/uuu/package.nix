{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,

  cmake,
  installShellFiles,
  pkg-config,

  bzip2,
  libusb1,
  openssl,
  tinyxml-2,
  zlib,
  zstd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "uuu";
  version = "1.5.233";

  src = fetchFromGitHub {
    owner = "nxp-imx";
    repo = "mfgtools";
    rev = "uuu_${finalAttrs.version}";
    hash = "sha256-x3C9bEE99XOIpnPjVV7Je5mfdhwN0nTkiuBxrwWZ7CI=";
  };

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "uuu_([0-9.]+)"
    ];
  };

  nativeBuildInputs = [
    cmake
    installShellFiles
    pkg-config
  ];

  buildInputs = [
    bzip2
    libusb1
    openssl
    tinyxml-2
    zlib
    zstd
  ];

  postPatch = ''
    # Avoid the need of calling Git during the build.
    echo "uuu_${finalAttrs.version}" > .tarball-version
  '';

  postInstall = ''
    installShellCompletion --bash --name uuu.bash ${./completion.bash}

    mkdir -p $out/lib/udev/rules.d
    cat <($out/bin/uuu -udev) > $out/lib/udev/rules.d/70-uuu.rules
  '';

  doInstallCheck = true;

  meta = with lib; {
    description = "Freescale/NXP I.MX Chip image deploy tools";
    homepage = "https://github.com/nxp-imx/mfgtools";
    license = licenses.bsd3;
    maintainers = with maintainers; [ otavio ];
    mainProgram = "uuu";
    platforms = platforms.all;
  };
})
