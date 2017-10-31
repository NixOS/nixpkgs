{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "cminpack-1.3.4";
  
  src = fetchurl {
    url = "http://devernay.free.fr/hacks/cminpack/${name}.tar.gz";
    sha256 = "1jh3ymxfcy3ykh6gnvds5bbkf38aminvjgc8halck356vkvpnl9v";
  };

  patchPhase = ''
    sed -i s,/usr/local,$out, Makefile
  '';

  preInstall = ''
    mkdir -p $out/lib $out/include
  '';

  meta = {
    homepage = http://devernay.free.fr/hacks/cminpack/cminpack.html;
    license = stdenv.lib.licenses.bsd3;
    description = "Software for solving nonlinear equations and nonlinear least squares problems";
    platforms = stdenv.lib.platforms.linux;
  };

}
