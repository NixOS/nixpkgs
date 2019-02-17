{ stdenv, python, fetchPypi, makeWrapper, unzip }:

let
  wheel_source = fetchPypi {
    pname = "wheel";
    version = "0.32.2";
    format = "wheel";
    sha256 = "1216licil12jjixfqvkb84xkync5zz0fdc2kgzhl362z3xqjsgn9";
  };
  setuptools_source = fetchPypi {
    pname = "setuptools";
    version = "40.6.3";
    format = "wheel";
    sha256 = "e2c1ce9a832f34cf7a31ed010aabcab5008eb65ce8f2aadc04622232c14bdd0b";
  };

in stdenv.mkDerivation rec {
  pname = "pip";
  version = "18.1";
  name = "${python.libPrefix}-bootstrapped-${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    format = "wheel";
    sha256 = "7909d0a0932e88ea53a7014dfd14522ffef91a464daaaf5c573343852ef98550";
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
