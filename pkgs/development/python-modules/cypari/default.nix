{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchurl,
  setuptools,
  pythonOlder,
  cython,
  bash,
  perl,
  gnum4,
  texliveBasic,
}:

buildPythonPackage rec {
  pname = "cypari";
  version = "2.5.5";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "3-manifolds";
    repo = "CyPari";
    rev = "${version}_as_released";
    sha256 = "sha256:0ikglb00ll3zyw46mipc6j53jh2j2avm41929hj667h3mga4x7s4";
  };

  pariVersion = "pari-2.15.4";
  pariSrc = fetchurl {
    url = "https://pari.math.u-bordeaux.fr/pub/pari/OLD/2.15/${pariVersion}.tar.gz";
    sha256 = "sha256-w1Rb/uDG37QLd/tLurr5mdguYAabn20ovLbPAEyMXA8=";
  };

  gmpVersion = "gmp-6.3.0";
  gmpSrc = fetchurl {
    url = "https://ftp.gnu.org/gnu/gmp/${gmpVersion}.tar.bz2";
    sha256 = "sha256-rCghGnz7YJuuLiyNYFjWbI/pZDT3QM9v4uR7AA0cIMs=";
  };

  NIX_LDFLAGS = "-lc";

  postPatch = ''
    substituteInPlace ./setup.py --replace "/bin/bash" "${bash}/bin/bash"
    ln -s ${pariSrc} ${pariVersion}.tar.gz
    ln -s ${gmpSrc} ${gmpVersion}.tar.bz2
  '';

  build-system = [ setuptools ];

  nativeBuildInputs = [
    cython
    gnum4
    perl
    texliveBasic
  ];

  doCheck = true;

  pythonImportsCheck = [ "cypari" ];

  meta = with lib; {
    description = "Sage's PARI extension, modified to stand alone.";
    homepage = "https://github.com/3-manifolds/CyPari";
    license = licenses.gpl2;
    maintainers = with maintainers; [ noiioiu ];
  };
}
