{ stdenv, fetchurl, python }:

stdenv.mkDerivation rec {
  name = "cmdstan-2.9.0";

  src = fetchurl {
    url = "https://github.com/stan-dev/cmdstan/releases/download/v2.9.0/cmdstan-2.9.0.tar.gz";
    sha256 = "08bim6nxgam989152hm0ga1rfb33mr71pwsym1nmfmavma68bwm9";
  };

  buildFlags = "build";
  enableParallelBuilding = true;
  nativeBuildInputs = stdenv.lib.optional doCheck python;

  doCheck = true;
  checkPhase = "python ./runCmdStanTests.py src/test/interface";  # see #5368

  installPhase = ''
    mkdir -p $out/opt $out/bin
    cp -r . $out/opt/cmdstan
    ln -s $out/opt/cmdstan/bin/stanc $out/bin/stanc
    ln -s $out/opt/cmdstan/bin/stansummary $out/bin/stansummary
    cat > $out/bin/stan <<EOF
    #!/bin/sh
    make -C $out/opt/cmdstan "\$(realpath "\$1")"
    EOF
    chmod a+x $out/bin/stan
  '';

  meta = {
    description = "Command-line interface to Stan";
    longDescription = ''
      Stan is a probabilistic programming language implementing full Bayesian
      statistical inference with MCMC sampling (NUTS, HMC), approximate Bayesian
      inference with Variational inference (ADVI) and penalized maximum
      likelihood estimation with Optimization (L-BFGS).
    '';
    homepage = http://mc-stan.org/interfaces/cmdstan.html;
    license = stdenv.lib.licenses.bsd3;
    platforms = stdenv.lib.platforms.linux;
  };
}
