{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  openmp,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vid.stab";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "georgmartius";
    repo = "vid.stab";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8YyIBYp3/tThQBrnZsiusKyhP2kO0qAsxTwy9mVQiRk=";
  };

  nativeBuildInputs = [ cmake ];

  propagatedBuildInputs = lib.optionals stdenv.cc.isClang [ openmp ];

  strictDeps = true;
  __structuredAttrs = true;

  passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;

  meta = {
    description = "Video stabilization library";
    homepage = "http://public.hronopik.de/vid.stab/";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    platforms = lib.platforms.all;
    # Upstream is aware of wrong version in .pc file; assume it will be correct at next release:
    # https://github.com/georgmartius/vid.stab/commit/a333a94fa60fe08962116b38e902072beee66fd0
    # https://github.com/georgmartius/vid.stab/commit/3ef501808ccae1bcb7283a9b082163a961b8ffd0
    pkgConfigModules = [ "vidstab" ];
  };
})
