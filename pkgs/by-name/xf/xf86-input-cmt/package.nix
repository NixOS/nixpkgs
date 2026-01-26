{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  xorgserver,
  xorgproto,
  utilmacros,
  libgestures,
  libevdevc,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xf86-input-cmt";
  version = "2.0.2";
  src = fetchFromGitHub {
    owner = "hugegreenbug";
    repo = "xf86-input-cmt";
    rev = "v${finalAttrs.version}";
    sha256 = "1cnwf518nc0ybc1r3rsgc1gcql1k3785khffv0i4v3akrm9wdw98";
  };

  postPatch = ''
    patchShebangs ./apply_patches.sh
    ./apply_patches.sh
  '';

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    xorgserver
    xorgproto
    utilmacros
    libgestures
    libevdevc
  ];

  configureFlags = [
    "--with-sdkdir=${placeholder "out"}"
  ];

  meta = {
    description = "Chromebook touchpad driver";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
    homepage = "https://www.github.com/hugegreenbug/xf86-input-cmt";
    maintainers = with lib.maintainers; [ kcalvinalvin ];
  };
})
