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
  version = "1.5.243";

  src = fetchFromGitHub {
    owner = "nxp-imx";
    repo = "mfgtools";
    rev = "uuu_${finalAttrs.version}";
    hash = "sha256-+m3r/QxOnTjemqIaZ/2cxDHtHlw7qxu9PbTsQYyMaEY=";
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

  meta = {
    description = "Freescale/NXP I.MX Chip image deploy tools";
    homepage = "https://github.com/nxp-imx/mfgtools";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ otavio ];
    mainProgram = "uuu";
    platforms = lib.platforms.all;
  };
})
