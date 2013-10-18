{ stdenv, requireFile }:

stdenv.mkDerivation {
  name = "gurobi-5.6.0";

  src = requireFile {
    name = "gurobi5.6.0_linux64.tar.gz";
    sha256 = "1qwfjyx5y71x97gkndqnl9h4xc8hl48zwcwss7jagqfj3gxwvnky";
    url = "http://www.gurobi.com/download/gurobi-optimizer";
  };

  installPhase = "mv linux64 $out";

  fixupPhase = ''
    interp=`cat $NIX_GCC/nix-support/dynamic-linker`
    find $out/bin -type f -executable -exec patchelf --interpreter "$interp" --set-rpath $out/lib {} \;
  '';

  meta = {
    description = "State-of-the-art mathematical programming solver";
    homepage = http://www.gurobi.com/;
    license = "unfree";
    maintainers = [ stdenv.lib.maintainers.shlevy ];
  };
}
