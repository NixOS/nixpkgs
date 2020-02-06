{ stdenv, fetchurl, fetchpatch, python, root, makeWrapper, zlib, withRootSupport ? false }:

stdenv.mkDerivation rec {
  pname = "yoda";
  version = "1.7.7";

  src = fetchurl {
    url = "https://www.hepforge.org/archive/yoda/YODA-${version}.tar.bz2";
    sha256 = "1ki88rscnym0vjxpfgql8m1lrc7vm1jb9w4jhw9lvv3rk84lpdng";
  };

  patches = [
    # fixes "TypeError: expected bytes, str found" in writeYODA()
    (fetchpatch {
      url = "https://gitlab.com/hepcedar/yoda/commit/d2bbbe92912457f8a29b440cbfa0b39daf28ec34.diff";
      sha256 = "1x60piswpxwak61r2sdclsc8pzi1fshpkjnxlyflsa1iap77vkq8";
    })
  ];

  nativeBuildInputs = with python.pkgs; [ cython makeWrapper ];
  buildInputs = [ python ]
    ++ (with python.pkgs; [ numpy matplotlib ])
    ++ stdenv.lib.optional withRootSupport root;
  propagatedBuildInputs = [ zlib ];

  enableParallelBuilding = true;

  postPatch = ''
    touch pyext/yoda/*.{pyx,pxd}
  '';

  postInstall = ''
    for prog in "$out"/bin/*; do
      wrapProgram "$prog" --set PYTHONPATH $PYTHONPATH:$(toPythonPath "$out")
    done
  '';

  hardeningDisable = [ "format" ];

  meta = {
    description = "Provides small set of data analysis (specifically histogramming) classes";
    license     = stdenv.lib.licenses.gpl3;
    homepage    = https://yoda.hepforge.org;
    platforms   = stdenv.lib.platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ veprbl ];
  };
}
