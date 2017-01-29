{ stdenv, python, fetchurl, makeWrapper, unzip, fetchUniversalWheel, writeText }:

let
  wheel_whl = fetchUniversalWheel {
    name = "wheel-0.29.0";
    sha256 = "ea8033fc9905804e652f75474d33410a07404c1a78dd3c949a66863bd1050ebd";
  };
  setuptools_whl = fetchUniversalWheel {
    name = "setuptools-30.2.0";
    sha256 = "b7e7b28d6a728ea38953d66e12ef400c3c153c523539f1b3997c5a42f3770ff1";
  };
  argparse_whl = fetchUniversalWheel {
    name = "argparse-1.4.0";
    sha256 = "0533cr5w14da8wdb2q4py6aizvbvsdbk3sj7m1jx9lwznvnlf5n3";
  };

  pip_whl = fetchUniversalWheel {
    name = "pip-9.0.1";
    sha256 = "690b762c0a8460c303c089d5d0be034fb15a5ea2b75bdf565f40421f542fefb0";
  };

  inputs = [
    wheel_whl
    setuptools_whl
    pip_whl
  ] ++ stdenv.lib.optional (python.isPy26 or false) argparse_whl;

  
in stdenv.mkDerivation rec {
  name = "${python.libPrefix}-bootstrapped-pip-${version}";
  version = "9.0.1";

  PYTHONPATH = stdenv.lib.concatStringsSep ":" inputs;
  patchPhase = ''
    mkdir -p $out/bin
  '';
  srcs = inputs;
  unpackPhase = "true";
  buildInputs = [ python makeWrapper];

  installPhase = ''

    # install pip binary
    echo '#!${python.interpreter}' > $out/bin/pip
    echo 'import sys;from pip import main' >> $out/bin/pip
    echo 'sys.exit(main())' >> $out/bin/pip
    chmod +x $out/bin/pip

    wrapProgram $out/bin/pip --prefix PYTHONPATH ":" $PYTHONPATH/
  '';
}
