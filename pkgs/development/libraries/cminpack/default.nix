{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "cminpack-1.1.2";
  
  src = fetchurl {
    url = http://devernay.free.fr/hacks/cminpack/cminpack-1.1.2.tar.gz;
    sha256 = "0sd8gqk7npyiiiz2jym8q89d9gqx8fig0mnx63swkwmp4lqmmxww";
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
