{ lib
, stdenv
, fetchFromGitHub
, nix-update-script

, cmake
, installShellFiles
, pkg-config

, bzip2
, libusb1
, openssl
, zlib
, zstd
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "uuu";
  version = "1.5.125";

  src = fetchFromGitHub {
    owner = "nxp-imx";
    repo = "mfgtools";
    rev = "uuu_${finalAttrs.version}";
    hash = "sha256-f9Nt303xXZzLSu3GtOEpyaL91WVFUmKO7mxi8UNX3go=";
  };

  passthru.updateScript = nix-update-script { };

  nativeBuildInputs = [
    cmake
    installShellFiles
    pkg-config
  ];

  buildInputs = [
    bzip2
    libusb1
    openssl
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

  meta = with lib; {
    description = "Freescale/NXP I.MX Chip image deploy tools";
    homepage = "https://github.com/nxp-imx/mfgtools";
    license = licenses.bsd3;
    maintainers = with maintainers; [ otavio ];
    mainProgram = "uuu";
    platforms = platforms.all;
  };
})
