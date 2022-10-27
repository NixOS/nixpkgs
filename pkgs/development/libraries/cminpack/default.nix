{lib, stdenv, fetchurl}:

stdenv.mkDerivation rec {
  pname = "cminpack";
  version = "1.3.6";

  src = fetchurl {
    url = "http://devernay.free.fr/hacks/cminpack/cminpack-${version}.tar.gz";
    sha256 = "17yh695aim508x1kn9zf6g13jxwk3pi3404h5ix4g5lc60hzs1rw";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace '/usr/local' '${placeholder "out"}' \
      --replace 'gcc' '${stdenv.cc.targetPrefix}cc' \
      --replace 'ranlib -t' '${stdenv.cc.targetPrefix}ranlib' \
      --replace 'ranlib' '${stdenv.cc.targetPrefix}ranlib'
  '';

  preInstall = ''
    mkdir -p $out/lib $out/include
  '';

  meta = {
    homepage = "http://devernay.free.fr/hacks/cminpack/cminpack.html";
    license = lib.licenses.bsd3;
    description = "Software for solving nonlinear equations and nonlinear least squares problems";
    platforms = lib.platforms.all;
  };

}
