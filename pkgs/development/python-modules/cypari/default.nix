{
  lib,
  python,
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
  pariVersion = "2.15.4";
  gmpVersion = "6.3.0";

  pariSrc = fetchurl {
    url = "https://pari.math.u-bordeaux.fr/pub/pari/OLD/${lib.versions.majorMinor pariVersion}/pari-${pariVersion}.tar.gz";
    hash = "sha256-w1Rb/uDG37QLd/tLurr5mdguYAabn20ovLbPAEyMXA8=";
  };

  gmpSrc = fetchurl {
    url = "https://ftp.gnu.org/gnu/gmp/gmp-${gmpVersion}.tar.bz2";
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

  postPatch = ''
    substituteInPlace ./setup.py \
      --replace-fail "/bin/bash" "${lib.getExe bash}"
    # final character is stripped from PARI error messages for some reason
    substituteInPlace ./cypari/handle_error.pyx \
      --replace-fail "not a function in function call" "not a function in function cal"
    ln -s ${pariSrc} ${pariSrc.name}
    ln -s ${gmpSrc} ${gmpSrc.name}
  '';

  build-system = [
    setuptools
    cython
  ];

  NIX_LDFLAGS = "-lc";

  nativeBuildInputs = [
    gnum4
    perl
    texliveBasic
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
