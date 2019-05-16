{ stdenv, python, fetchPypi, makeWrapper, unzip }:

let
  wheel_source = fetchPypi {
    pname = "wheel";
    version = "0.33.1";
    format = "wheel";
    sha256 = "8eb4a788b3aec8abf5ff68d4165441bc57420c9f64ca5f471f58c3969fe08668";
  };
  setuptools_source = fetchPypi {
    pname = "setuptools";
    version = "41.0.0";
    format = "wheel";
    sha256 = "e67486071cd5cdeba783bd0b64f5f30784ff855b35071c8670551fd7fc52d4a1";
  };

in stdenv.mkDerivation rec {
  pname = "pip";
  version = "19.0.3";
  name = "${python.libPrefix}-bootstrapped-${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    format = "wheel";
    sha256 = "bd812612bbd8ba84159d9ddc0266b7fbce712fc9bc98c82dee5750546ec8ec64";
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
