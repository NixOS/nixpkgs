{ lib, stdenv, fetchurl, python, root, makeWrapper, zlib, withRootSupport ? false }:

stdenv.mkDerivation rec {
  pname = "yoda";
  version = "1.9.0";

  src = fetchurl {
    url = "https://www.hepforge.org/archive/yoda/YODA-${version}.tar.bz2";
    sha256 = "1x7xi6w7lb92x8202kbaxgqg1sly534wana4f38l3gpbzw9dwmcs";
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
    license     = lib.licenses.gpl3;
    homepage    = "https://yoda.hepforge.org";
    platforms   = lib.platforms.unix;
    maintainers = with lib.maintainers; [ veprbl ];
  };
}
