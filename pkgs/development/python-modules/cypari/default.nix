{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchurl,
  setuptools,
  cython,
  bash,
  perl,
  gnum4,
  texliveBasic,
}:

let
  pariVersion = "pari-2.15.4";
  gmpVersion = "gmp-6.3.0";

  pariSrc = fetchurl {
    url = "https://pari.math.u-bordeaux.fr/pub/pari/OLD/2.15/${pariVersion}.tar.gz";
    hash = "sha256-w1Rb/uDG37QLd/tLurr5mdguYAabn20ovLbPAEyMXA8=";
  };

  gmpSrc = fetchurl {
    url = "https://ftp.gnu.org/gnu/gmp/${gmpVersion}.tar.bz2";
    hash = "sha256-rCghGnz7YJuuLiyNYFjWbI/pZDT3QM9v4uR7AA0cIMs=";
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

  NIX_LDFLAGS = "-lc";

  postPatch = ''
    substituteInPlace ./setup.py --replace "/bin/bash" "${lib.getExe bash}"
    ln -s ${pariSrc} ${pariVersion}.tar.gz
    ln -s ${gmpSrc} ${gmpVersion}.tar.bz2
  '';

  build-system = [
    setuptools
    cython
  ];

  nativeBuildInputs = [
    gnum4
    perl
    texliveBasic
  ];

  pythonImportsCheck = [ "cypari" ];

  meta = {
    description = "Sage's PARI extension, modified to stand alone";
    homepage = "https://github.com/3-manifolds/CyPari";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ noiioiu ];
    changelog = "https://github.com/3-manifolds/CyPari/releases/tag/${src.tag}";
  };
}
