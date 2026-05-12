{
  lib,
  stdenv,
  fetchFromGitHub,
  gprbuild,
  gnat,
  vss-text,
  enableShared ? !stdenv.hostPlatform.isStatic,
}:

let
  makeTarget = if enableShared then "all-libs" else "libs-release_static";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "vss-extra";
  version = "26.0.0";

  src = fetchFromGitHub {
    owner = "AdaCore";
    repo = "vss-extra";
    tag = "v${finalAttrs.version}";
    hash = "sha256-J13v2Rx2Yl06Fhs+FmyVEul0tfS2Xw/qsIdWXUrls9c=";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail "-j0" "-j$NIX_BUILD_CORES"
  '';

  nativeBuildInputs = [
    gnat
    gprbuild
  ];

  propagatedBuildInputs = [
    vss-text
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
    description = "Ada libraries for JSON, Regexp, XML and more";
    homepage = "https://github.com/AdaCore/vss-extra";
    license = lib.licenses.llvm-exception;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.sempiternal-aurora ];
  };
})
