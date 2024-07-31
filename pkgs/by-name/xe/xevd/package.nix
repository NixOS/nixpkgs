{
  lib,
  fetchFromGitHub,
  fetchpatch2,
  stdenv,
  gitUpdater,
  testers,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xevd";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "mpeg5";
    repo = "xevd";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Dc2V77t+DrZo9252FAL0eczrmikrseU02ob2RLBdVvU=";
  };

  patches = lib.optionals (!lib.versionOlder "0.5.0" finalAttrs.version) [
    (fetchpatch2 {
      url = "https://github.com/mpeg5/xevd/commit/7eda92a6ebb622189450f7b63cfd4dcd32fd6dff.patch?full_index=1";
      hash = "sha256-Ru7jGk1b+Id5x1zaiGb7YKZGTNaTcArZGYyHbJURfgs=";
    })
  ];

  postPatch = ''
    echo v$version > version.txt
  '';

  nativeBuildInputs = [ cmake ];

  postInstall = ''
    ln $dev/include/xevd/* $dev/include/
  '';

  outputs = [
    "out"
    "lib"
    "dev"
  ];

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };
  passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;

  meta = {
    homepage = "https://github.com/mpeg5/xevd";
    description = "eXtra-fast Essential Video Decoder, MPEG-5 EVC";
    license = lib.licenses.bsd3;
    mainProgram = "xevd_app";
    pkgConfigModules = [ "xevd" ];
    maintainers = with lib.maintainers; [ jopejoe1 ];
    platforms = lib.platforms.all;
    # Currently only supports gcc and msvc as compiler, the limitation for clang gets removed in the next release, but that does not fix building on darwin.
    broken = !stdenv.hostPlatform.isx86 || !stdenv.cc.isGNU;
  };
})
