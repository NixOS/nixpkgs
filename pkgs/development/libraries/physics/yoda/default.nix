{ lib, stdenv, fetchurl, fetchpatch, python, root, makeWrapper, zlib, withRootSupport ? false }:

stdenv.mkDerivation rec {
  pname = "yoda";
  version = "1.9.6";

  src = fetchurl {
    url = "https://www.hepforge.org/archive/yoda/YODA-${version}.tar.bz2";
    hash = "sha256-IVI/ova2yPM0iVnzqUhzSpMMollR08kZC0Qk4Tc18qQ=";
  };

  nativeBuildInputs = with python.pkgs; [ cython makeWrapper ];
  buildInputs = [ python ]
    ++ (with python.pkgs; [ numpy matplotlib ])
    ++ lib.optional withRootSupport root;
  propagatedBuildInputs = [ zlib ];

  enableParallelBuilding = true;

  postPatch = ''
    touch pyext/yoda/*.{pyx,pxd}
    patchShebangs .
  '';

  postInstall = ''
    for prog in "$out"/bin/*; do
      wrapProgram "$prog" --set PYTHONPATH $PYTHONPATH:$(toPythonPath "$out")
    done
  '';

  hardeningDisable = [ "format" ];

  doInstallCheck = true;
  installCheckTarget = "check";

  meta = {
    description = "Provides small set of data analysis (specifically histogramming) classes";
    license = lib.licenses.gpl3Only;
    homepage = "https://yoda.hepforge.org";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ veprbl ];
  };
}
