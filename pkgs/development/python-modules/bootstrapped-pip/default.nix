{ stdenv, python, fetchPypi, fetchurl, makeWrapper, unzip }:

let
  wheel_source = fetchPypi {
    pname = "wheel";
    version = "0.31.0";
    format = "wheel";
    sha256 = "9cdc8ab2cc9c3c2e2727a4b67c22881dbb0e1c503d592992594c5e131c867107";
  };
  setuptools_source = fetchPypi {
    pname = "setuptools";
    version = "39.0.1";
    format = "wheel";
    sha256 = "8010754433e3211b9cdbbf784b50f30e80bf40fc6b05eb5f865fab83300599b8";
  };

in stdenv.mkDerivation rec {
  pname = "pip";
  version = "10.0.1";
  name = "${python.libPrefix}-bootstrapped-${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    format = "wheel";
    sha256 = "717cdffb2833be8409433a93746744b59505f42146e8d37de6c62b430e25d6d7";
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
