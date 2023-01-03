{ lib, stdenv, fetchurl, python3, runtimeShell }:

let
  # FIXME: remove conditional on future release
  version = if stdenv.isx86_64 then "2.31.0" else "2.30.1";
  # includes stanc binaries needed to build cmdstand
  srcs = rec {
    aarch64-linux = fetchurl {
      url = "https://github.com/stan-dev/cmdstan/releases/download/v${version}/cmdstan-${version}-linux-arm64.tar.gz";
      sha256 = "sha256-oj/7JHT4LZcRAHiA2KbM6pZbOe6C98Ff//cNsG9DIm8=";
    };
    x86_64-darwin = fetchurl {
      url = "https://github.com/stan-dev/cmdstan/releases/download/v${version}/cmdstan-${version}.tar.gz";
      sha256 = "sha256-BMqRRWIC/Z7It2qkESJd9L3ycyxvA6NHiWbAvzVMzIQ=";
    };
    x86_64-linux = x86_64-darwin;
  };
  src = srcs.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
in
stdenv.mkDerivation rec {
  pname = "cmdstan";
  inherit version src;

  buildFlags = [ "build" ];
  enableParallelBuilding = true;

  doCheck = true;
  checkInputs = [ python3 ];

  CXXFLAGS = lib.optionalString stdenv.isDarwin "-D_BOOST_LGAMMA";

  postPatch = ''
    substituteInPlace stan/lib/stan_math/make/libraries \
      --replace "/usr/bin/env bash" "bash"
    patchShebangs .
  '' + lib.optionalString stdenv.isAarch64 ''
    sed -z -i "s/TEST(CommandStansummary, check_console_output).*TEST(CommandStansummary, check_csv_output)/TEST(CommandStansummary, check_csv_output)/" \
      src/test/interface/stansummary_test.cpp
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
  preFixup = "rm -rf stan";

  meta = {
    description = "Command-line interface to Stan";
    longDescription = ''
      Stan is a probabilistic programming language implementing full Bayesian
      statistical inference with MCMC sampling (NUTS, HMC), approximate Bayesian
      inference with Variational inference (ADVI) and penalized maximum
      likelihood estimation with Optimization (L-BFGS).
    '';
    homepage = "https://mc-stan.org/interfaces/cmdstan.html";
    license = lib.licenses.bsd3;
    platforms = [ "aarch64-linux" "x86_64-darwin" "x86_64-linux" ];
  };
}
