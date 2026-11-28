{
  lib,
  stdenv,
  fetchFromGitHub,
  gprbuild,
  gnat,
  fetchpatch2,
  enableShared ? !stdenv.hostPlatform.isStatic,
}:

let
  makeTarget = if enableShared then "all-libs" else "libs-release_static";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "vss-text";
  version = "26.0.0";

  src = fetchFromGitHub {
    owner = "AdaCore";
    repo = "vss-text";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mSp5mmXHODLs2npVnjgTPpGSxVqIETdZCBulvBoK6dI=";
  };

  patches = [
    # vss-strings-cursors-iterators-characters.adb:24:64: error: actual for aliased formal "Position" has wrong accessibility in return (RM 6.4.1(6.4))
    (fetchpatch2 {
      url = "https://github.com/AdaCore/vss-text/commit/7dd4c487cac67b822104f65160c97aa252055c96.patch?full_index=1";
      hash = "sha256-8ObEEQEKYr7UH86sg57s81JrSOXVj4k/zb2S/mRa/J0=";
    })
  ];

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail "-j0" "-j$NIX_BUILD_CORES"
  '';

  nativeBuildInputs = [
    gnat
    gprbuild
  ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ];

  buildFlags = [
    "build-${makeTarget}"
  ];

  # Cannot run the checks, as it requires downloading extra test data
  doCheck = false;

  installTargets = [
    "install-${makeTarget}"
  ];

  meta = {
    description = "A high level Unicode text processing library.";
    homepage = "https://github.com/AdaCore/vss-text";
    license = lib.licenses.llvm-exception;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.sempiternal-aurora ];
  };
})
