{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "cminpack-1.1.1";
  
  src = fetchurl {
    url = http://pr.willowgarage.com/downloads/cminpack-1.1.1.tar.gz;
    sha256 = "0bi86c9712i68nyv8d52f7wgyb35kik14iwj4rpxcnz91m7wgacp";
  };

  patchPhase = ''
    sed -i s,/usr/local,$out, Makefile
  '';

  preInstall = ''
    ensureDir $out/lib $out/include
  '';

  meta = {
    homepage = http://www.ros.org/wiki/cminpack;
    license = "BSD";
    description = "Software for solving nonlinear equations and nonlinear least squares problems";
  };

}
