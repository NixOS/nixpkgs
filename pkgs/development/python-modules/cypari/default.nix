{
  lib,
  python,
  buildPythonPackage,
  fetchFromGitHub,
  fetchurl,
  setuptools,
  cython,
  pari,
  pkgsStatic,
  perl,
}:

let
  pariStatic = pari.overrideAttrs rec {
    version = "2.15.4";
    src = fetchurl {
      url = "https://pari.math.u-bordeaux.fr/pub/pari/OLD/${lib.versions.majorMinor version}/pari-${version}.tar.gz";
      hash = "sha256-w1Rb/uDG37QLd/tLurr5mdguYAabn20ovLbPAEyMXA8=";
    };
    installTargets = [
      "install"
      "install-lib-sta"
    ];
  };
in

buildPythonPackage rec {
  pname = "cypari";
  version = "2.5.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "3-manifolds";
    repo = "CyPari";
    tag = "${version}_as_released";
    hash = "sha256-RJ9O1KsDHmMkTCIFUrcSUkA5ijTsxmoI939QCsCib0Y=";
  };

  postPatch = ''
    # final character is stripped from this PARI error message for some reason
    substituteInPlace ./cypari/handle_error.pyx \
      --replace-fail "not a function in function call" "not a function in function cal"
  '';

  preBuild = ''
    mkdir libcache
    ln -s ${pkgsStatic.gmp} libcache/gmp
    ln -s ${pariStatic} libcache/pari
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
    rm -r cypari
    ${python.interpreter} -m cypari.test
    runHook postCheck
  '';

  meta = {
    description = "Sage's PARI extension, modified to stand alone";
    homepage = "https://github.com/3-manifolds/CyPari";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ noiioiu ];
    changelog = "https://github.com/3-manifolds/CyPari/releases/tag/${src.tag}";
  };
}
