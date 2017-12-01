{ stdenv, python, fetchPypi, fetchurl, makeWrapper, unzip }:

let
  wheel_source = fetchPypi {
    pname = "wheel";
    version = "0.30.0";
    format = "wheel";
    sha256 = "e721e53864f084f956f40f96124a74da0631ac13fbbd1ba99e8e2b5e9cafdf64";
  };
  setuptools_source = fetchPypi {
    pname = "setuptools";
    version = "38.2.3";
    format = "wheel";
    sha256 = "0c4j3jiiwc0h1bdv4xklinp90spgvgiv5fsxp119hif9934nfxfs";
  };

  # TODO: Shouldn't be necessary anymore for pip > 9.0.1!
  # https://github.com/NixOS/nixpkgs/issues/26392
  # https://github.com/pypa/setuptools/issues/885
  pkg_resources = fetchurl {
    url = "https://raw.githubusercontent.com/pypa/setuptools/v36.0.1/pkg_resources/__init__.py";
    sha256 = "1wdnq3mammk75mifkdmmjx7yhnpydvnvi804na8ym4mj934l2jkv";
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
    # TODO: Shouldn't be necessary anymore for pip > 9.0.1!
    cp ${pkg_resources} $out/${python.sitePackages}/pip/_vendor/pkg_resources/__init__.py
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
