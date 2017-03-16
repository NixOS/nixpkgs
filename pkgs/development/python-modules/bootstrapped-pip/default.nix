{ stdenv, python, fetchPypi, makeWrapper, unzip, buildPythonPackage }:

let
  version = "9.0.1";
  # Hash of the wheel
  sha256 = "690b762c0a8460c303c089d5d0be034fb15a5ea2b75bdf565f40421f542fefb0";
in buildPythonPackage rec {
  pname = "bootstrapped-pip";
  inherit version;
  name = "${pname}-${version}";
  format = "other";         # For bootstrapping
  catchConflicts = false;   # For bootstrapping

  # We download a wheel, but, because we cannot use `format = "wheel";` yet at this point
  # we manually install the wheel.
  src = fetchPypi {
    inherit version;
    pname = "pip";
    format = "wheel";
    sha256 = "690b762c0a8460c303c089d5d0be034fb15a5ea2b75bdf565f40421f542fefb0";
  };

  unpackPhase = ''
    mkdir -p $out/${python.sitePackages}
    unzip -d $out/${python.sitePackages} $src
  '';

  buildInputs = [ python makeWrapper unzip ];

  installPhase = ''
    mkdir -p $out/bin
    # install pip binary
    echo '#!${python.interpreter}' > $out/bin/pip
    echo 'import sys;from pip import main' >> $out/bin/pip
    echo 'sys.exit(main())' >> $out/bin/pip
    chmod +x $out/bin/pip

    # wrap binaries with PYTHONPATH
    for f in $out/bin/*; do
      wrapProgram $f --prefix PYTHONPATH ":" $out/${python.sitePackages}/
    done
  '';
}
