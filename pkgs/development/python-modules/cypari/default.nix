{
  lib,
  fetchFromGitHub,
  python,
  buildPythonPackage,
  nix-update-script,
  fetchurl,
  fetchpatch,

  # build-time dependencies
  setuptools,
  cython,
  perl,

  # static libraries
  pkgsStatic,
  gmpStatic ? pkgsStatic.gmp,
  pari,
  pariStatic_2_15 ? pari.overrideAttrs (
    finalAttrs: oldAttrs: {
      version = "2.15.4";
      src = fetchurl {
        url = "https://pari.math.u-bordeaux.fr/pub/pari/OLD/${lib.versions.majorMinor finalAttrs.version}/pari-${finalAttrs.version}.tar.gz";
        hash = "sha256-w1Rb/uDG37QLd/tLurr5mdguYAabn20ovLbPAEyMXA8=";
      };
      installTargets = [
        "install"
        "install-lib-sta"
      ];
    }
  ),
}:

buildPythonPackage rec {
  pname = "cypari";
  version = "2.5.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "3-manifolds";
    repo = "CyPari";
    tag = "${version}_as_released";
    hash = "sha256-pzxnrWkoPW7fpxLbUQ+drIrdrjqaAiNnDfe9ky2IxaA=";
  };

  patches = [
    (fetchpatch {
      name = "fix-build-with-cython-3_1.patch";
      url = "https://github.com/3-manifolds/CyPari/compare/17bf39dc4508f2e46de75b95c65982c627652b60...d6cb914d2bdc74a51cc2a9136204ebf47b3e7369.diff";
      hash = "sha256-c8sq80mYSMMvgFh7RXYwKcqwI7iVRQsm/8yaIL0+PHQ=";
    })
  ];

  preBuild = ''
    mkdir libcache
    ln -s ${gmpStatic} libcache/gmp
    ln -s ${pariStatic_2_15} libcache/pari
  '';

  build-system = [
    setuptools
    cython
  ];

  nativeBuildInputs = [
    perl
  ];

  pythonImportsCheck = [ "cypari" ];

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} -P -m cypari.test
    runHook postCheck
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "(.*)_as_released"
    ];
  };

  meta = {
    description = "Sage's PARI extension, modified to stand alone";
    homepage = "https://github.com/3-manifolds/CyPari";
    changelog = "https://github.com/3-manifolds/CyPari/releases/tag/${src.tag}";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      noiioiu
      alejo7797
    ];
  };
}
