{ stdenv, python, fetchPypi, makeWrapper, unzip }:

let
  wheel_source = fetchPypi {
    pname = "wheel";
    version = "0.29.0";
    format = "wheel";
    sha256 = "ea8033fc9905804e652f75474d33410a07404c1a78dd3c949a66863bd1050ebd";
  };
  setuptools_source = fetchPypi {
    pname = "setuptools";
    version = "36.0.1";
    format = "wheel";
    sha256 = "f2900e560efc479938a219433c48f15a4ff4ecfe575a65de385eeb44f2425587";
  };
in stdenv.mkDerivation rec {
  pname = "pip";
  version = "9.0.1";
  name = "${python.libPrefix}-bootstrapped-${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    format = "wheel";
    sha256 = "690b762c0a8460c303c089d5d0be034fb15a5ea2b75bdf565f40421f542fefb0";
  };

  unpackPhase = ''
    mkdir -p $out/${python.sitePackages}
    unzip -d $out/${python.sitePackages} $src
    unzip -d $out/${python.sitePackages} ${setuptools_source}
    unzip -d $out/${python.sitePackages} ${wheel_source}
  '';

  patchPhase = ''
    mkdir -p $out/bin
  '';

  buildInputs = [ python makeWrapper unzip ];

  installPhase = ''

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
