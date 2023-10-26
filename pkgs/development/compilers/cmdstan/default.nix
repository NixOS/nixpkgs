{ lib, stdenv, fetchFromGitHub, stanc, python3, buildPackages, runtimeShell }:

stdenv.mkDerivation rec {
  pname = "cmdstan";
  version = "2.33.1";

  src = fetchFromGitHub {
    owner = "stan-dev";
    repo = pname;
    rev = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-c+L/6PjW7YgmXHuKhKjiRofBRAhKYCzFCZ6BOX5AmC4=";
  };

  nativeBuildInputs = [ stanc ];

  buildFlags = [ "build" ];
  enableParallelBuilding = true;

  doCheck = true;
  nativeCheckInputs = [ python3 ];

  CXXFLAGS = lib.optionalString stdenv.isDarwin "-D_BOOST_LGAMMA";

  postPatch = ''
    substituteInPlace stan/lib/stan_math/make/libraries \
      --replace "/usr/bin/env bash" "bash"
    patchShebangs .
  '' + lib.optionalString stdenv.isAarch64 ''
    sed -z -i "s/TEST(CommandStansummary, check_console_output).*TEST(CommandStansummary, check_csv_output)/TEST(CommandStansummary, check_csv_output)/" \
      src/test/interface/stansummary_test.cpp
  '';

  preConfigure = ''
    mkdir -p bin
    ln -s ${buildPackages.stanc}/bin/stanc bin/stanc
  '';

  makeFlags = lib.optional stdenv.isDarwin "arch=${stdenv.hostPlatform.darwinArch}";

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

  meta = with lib; {
    description = "Command-line interface to Stan";
    longDescription = ''
      Stan is a probabilistic programming language implementing full Bayesian
      statistical inference with MCMC sampling (NUTS, HMC), approximate Bayesian
      inference with Variational inference (ADVI) and penalized maximum
      likelihood estimation with Optimization (L-BFGS).
    '';
    homepage = "https://mc-stan.org/interfaces/cmdstan.html";
    license = licenses.bsd3;
    maintainers = with maintainers; [ wegank ];
    platforms = platforms.unix;
  };
}
