{ lib, stdenv, fetchurl, fetchpatch, python, root, makeWrapper, zlib, withRootSupport ? false }:

stdenv.mkDerivation rec {
  pname = "yoda";
  version = "1.9.2";

  src = fetchurl {
    url = "https://www.hepforge.org/archive/yoda/YODA-${version}.tar.bz2";
    hash = "sha256-zb7j7fBMv2brJ+gUMMDTKFEJDC2embENe3wXdx0VTOA=";
  };

  patches = [
    # Prevent ROOT from initializing X11 or Cocoa (helps with sandboxing)
    (fetchpatch {
      url = "https://gitlab.com/hepcedar/yoda/-/commit/36c035f4f0385dec58702f09564ca66a14ca2c3e.diff";
      sha256 = "sha256-afB+y33TVNJtxY5As18EcutJEGDE4g0UzMxzA+YgICk=";
      excludes = [ "ChangeLog" ];
    })
  ];

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
  enableParallelChecking = false; # testreader consumes output of testwriter

  meta = {
    description = "Provides small set of data analysis (specifically histogramming) classes";
    license = lib.licenses.gpl3;
    homepage = "https://yoda.hepforge.org";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ veprbl ];
  };
}
