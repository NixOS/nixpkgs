{ stdenv, fetchurl, python, runtimeShell, bash }:

let
  name = "cmdstan";
  version = "2.25.0";
in stdenv.mkDerivation {
  name = "${name}-${version}";

  src = fetchurl {
    url =
      "https://github.com/stan-dev/cmdstan/releases/download/v2.25.0/${name}-${version}.tar.gz";
    sha256 = "sha256:0jjsp65cc5jm16c74378lcm17c4d7xn163vm0whg51nk2djhrnbb";
  };

  buildFlags = [ "build" ];
  enableParallelBuilding = true;

  # Hack to avoid TMPDIR in RPATHs.
  # Copied from https://github.com/NixOS/nixpkgs/commit/f5c568446a12dbf58836925c5487e5cdad1fa578
  preFixup = ''rm -rf "$(pwd)" && mkdir "$(pwd)" '';

  patchPhase = ''
    substituteInPlace stan/lib/stan_math/make/libraries --replace "/usr/bin/env bash" ${bash}/bin/bash

    patchShebangs .
      '';

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
    homepage = "https://mc-stan.org/interfaces/cmdstan.html";
    license = stdenv.lib.licenses.bsd3;
    platforms = stdenv.lib.platforms.all;
  };
}
