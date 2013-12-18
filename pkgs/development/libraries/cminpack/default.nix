{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "cminpack-1.3.2";
  
  src = fetchurl {
    url = http://devernay.free.fr/hacks/cminpack/cminpack-1.3.2.tar.gz;
    sha256 = "09bqr44wqancbdsc39lvhdz7rci3hknmlrrrzv46skvwx6rgk9x0";
  };

  patchPhase = ''
    sed -i s,/usr/local,$out, Makefile
  '';

  preInstall = ''
    mkdir -p $out/lib $out/include
  '';

  meta = {
    homepage = http://devernay.free.fr/hacks/cminpack/cminpack.html;
    license = "BSD";
    description = "Software for solving nonlinear equations and nonlinear least squares problems";
  };

}
