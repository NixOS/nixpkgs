{
  lib,
  fetchFromGitHub,
  python,
  buildPythonPackage,
  nix-update-script,
  fetchurl,

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

buildPythonPackage (finalAttrs: {
  pname = "cypari";
  version = "2.5.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "3-manifolds";
    repo = "CyPari";
    tag = "${finalAttrs.version}_as_released";
    hash = "sha256-t8nuov7BZNSEd5ReIKsArtLvwh7BWs7rfaTswdypKgg=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'requires = ["setuptools", "wheel", "cython==3.2.3"]' \
                     'requires = ["setuptools", "wheel", "cython"]'
  '';

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
    changelog = "https://github.com/3-manifolds/CyPari/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      noiioiu
      alejo7797
    ];
  };
})
