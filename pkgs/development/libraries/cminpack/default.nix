{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "cminpack-1.3.6";
  
  src = fetchurl {
    url = "http://devernay.free.fr/hacks/cminpack/${name}.tar.gz";
    sha256 = "17yh695aim508x1kn9zf6g13jxwk3pi3404h5ix4g5lc60hzs1rw";
  };

  patchPhase = ''
    sed -i s,/usr/local,$out, Makefile
  '';

  preInstall = ''
    mkdir -p $out/lib $out/include
  '';

  meta = {
    homepage = "http://devernay.free.fr/hacks/cminpack/cminpack.html";
    license = stdenv.lib.licenses.bsd3;
    description = "Software for solving nonlinear equations and nonlinear least squares problems";
    platforms = stdenv.lib.platforms.linux;
  };

}
