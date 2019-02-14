{ stdenv, python, fetchPypi, makeWrapper, unzip }:

let
  wheel_source = fetchPypi {
    pname = "wheel";
    version = "0.33.0";
    format = "wheel";
    sha256 = "b79ffea026bc0dbd940868347ae9eee36789b6496b6623bd2dec7c7c540a8f99";
  };
  setuptools_source = fetchPypi {
    pname = "setuptools";
    version = "40.8.0";
    format = "wheel";
    sha256 = "e8496c0079f3ac30052ffe69b679bd876c5265686127a3159cfa415669b7f9ab";
  };

in stdenv.mkDerivation rec {
  pname = "pip";
  version = "19.0.2";
  name = "${python.libPrefix}-bootstrapped-${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    format = "wheel";
    sha256 = "6a59f1083a63851aeef60c7d68b119b46af11d9d803ddc1cf927b58edcd0b312";
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
