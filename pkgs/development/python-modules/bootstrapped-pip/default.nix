{ stdenv, python, fetchPypi, makeWrapper, unzip }:

let
  wheel_source = fetchPypi {
    pname = "wheel";
    version = "0.31.1";
    format = "wheel";
    sha256 = "80044e51ec5bbf6c894ba0bc48d26a8c20a9ba629f4ca19ea26ecfcf87685f5f";
  };
  setuptools_source = fetchPypi {
    pname = "setuptools";
    version = "40.2.0";
    format = "wheel";
    sha256 = "ea3796a48a207b46ea36a9d26de4d0cc87c953a683a7b314ea65d666930ea8e6";
  };

in stdenv.mkDerivation rec {
  pname = "pip";
  version = "18.0";
  name = "${python.libPrefix}-bootstrapped-${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    format = "wheel";
    sha256 = "070e4bf493c7c2c9f6a08dd797dd3c066d64074c38e9e8a0fb4e6541f266d96c";
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

  nativeBuildInputs = [ makeWrapper unzip ];
  buildInputs = [ python ];

  installPhase = ''

    # install pip binary
    echo '#!${python.interpreter}' > $out/bin/pip
    echo 'import sys;from pip._internal import main' >> $out/bin/pip
    echo 'sys.exit(main())' >> $out/bin/pip
    chmod +x $out/bin/pip

    # wrap binaries with PYTHONPATH
    for f in $out/bin/*; do
      wrapProgram $f --prefix PYTHONPATH ":" $out/${python.sitePackages}/
    done
  '';
}
