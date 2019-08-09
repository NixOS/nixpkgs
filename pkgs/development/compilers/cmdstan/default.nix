{ stdenv, fetchurl, python, runtimeShell }:

stdenv.mkDerivation rec {
  name = "cmdstan-2.17.1";

  src = fetchurl {
    url = "https://github.com/stan-dev/cmdstan/releases/download/v2.17.1/cmdstan-2.17.1.tar.gz";
    sha256 = "1vq1cnrkvrvbfl40j6ajc60jdrjcxag1fi6kff5pqmadfdz9564j";
  };

  buildFlags = "build";
  enableParallelBuilding = true;

  doCheck = true;
  checkInputs = [ python ];
  checkPhase = "python ./runCmdStanTests.py src/test/interface"; # see #5368

  installPhase = ''
    mkdir -p $out/opt $out/bin
    cp -r . $out/opt/cmdstan
    ln -s $out/opt/cmdstan/bin/stanc $out/bin/stanc
    ln -s $out/opt/cmdstan/bin/stansummary $out/bin/stansummary
    cat > $out/bin/stan <<EOF
    #!${runtimeShell}
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
    homepage = https://mc-stan.org/interfaces/cmdstan.html;
    license = stdenv.lib.licenses.bsd3;
    platforms = stdenv.lib.platforms.all;
  };
}
