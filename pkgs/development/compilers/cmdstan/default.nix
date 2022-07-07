{ lib, stdenv, fetchurl, python3, runtimeShell }:

stdenv.mkDerivation rec {
  pname = "cmdstan";
  version = "2.29.2";

  # includes stanc binaries needed to build cmdstand
  src = fetchurl {
    url = "https://github.com/stan-dev/cmdstan/releases/download/v${version}/cmdstan-${version}.tar.gz";
    sha256 = "sha256-VntTH6c//fcGyqF+szROHftB6GmTyvi6QIdf+RAzUVM=";
  };

  buildFlags = [ "build" ];
  enableParallelBuilding = true;

  doCheck = true;
  checkInputs = [ python3 ];

  postPatch = ''
    substituteInPlace stan/lib/stan_math/make/libraries \
      --replace "/usr/bin/env bash" "bash"
    patchShebangs .
  '';

  checkPhase = ''
    ./runCmdStanTests.py -j$NIX_BUILD_CORES src/test/interface
  '';

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

  # Hack to ensure that patchelf --shrink-rpath get rids of a $TMPDIR reference.
  preFixup = "rm -rf $(pwd)";

  meta = {
    broken = (stdenv.isLinux && stdenv.isAarch64) || stdenv.isDarwin;
    description = "Command-line interface to Stan";
    longDescription = ''
      Stan is a probabilistic programming language implementing full Bayesian
      statistical inference with MCMC sampling (NUTS, HMC), approximate Bayesian
      inference with Variational inference (ADVI) and penalized maximum
      likelihood estimation with Optimization (L-BFGS).
    '';
    homepage = "https://mc-stan.org/interfaces/cmdstan.html";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
  };
}
