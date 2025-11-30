{
  stdenv,
  lib,
  fetchFromGitHub,
  libjpeg,
  libpng,
  libtiff,
  nix-update-script,
  perl,
  testers,
  tif22pnm,
  zlib,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "tif22pnm";
  version = "2014-01-09";

  src = fetchFromGitHub {
    owner = "pts";
    repo = "tif22pnm";
    tag = finalAttrs.version;
    hash = "sha256-mkr17kDxCZyL65ZZRV5fEen4lVtD9Zm804P7C1zqtE0=";
  };

  postPatch = ''
    patchShebangs do.sh
  '';

  nativeBuildInputs = [ perl ];

  buildInputs = [
    libjpeg
    libpng
    libtiff
    zlib
  ];

  preInstall = ''
    mkdir --parents $out/bin
  '';

  NIX_LDFLAGS = "-lm";

  passthru = {
    tests.version = testers.testVersion {
      package = tif22pnm;
      version = "0.12";
    };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "TIFF and PNG to PNM converter";
    homepage = "https://github.com/pts/tif22pnm";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ jwillikers ];
    mainProgram = "tif22pnm";
  };
})
