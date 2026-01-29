{
  lib,
  fetchFromGitHub,
  python,
  buildPythonPackage,

  # build-time dependencies
  setuptools,
  cython,
  perl,

  # static libraries
  pkgsStatic,
  gmpStatic ? pkgsStatic.gmp,
  pariStatic_2_15,
}:

buildPythonPackage {
  pname = "cypari";
  version = "2.5.6-unstable-2026-01-05";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "3-manifolds";
    repo = "CyPari";
    rev = "d6cb914d2bdc74a51cc2a9136204ebf47b3e7369";
    hash = "sha256-p0UuKjcRjX6WBkZKpHkmynUtk3z81XtHyxqx0myza7U=";
  };

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

  meta = {
    description = "Sage's PARI extension, modified to stand alone";
    homepage = "https://github.com/3-manifolds/CyPari";
    changelog = "https://github.com/3-manifolds/CyPari/releases/tag/2.5.6_as_released";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      noiioiu
      alejo7797
    ];
  };
}
