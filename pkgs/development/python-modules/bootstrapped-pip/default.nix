{ stdenv, python, fetchurl, makeWrapper, unzip }:

let
  wheel_source = fetchurl {
    url = "https://pypi.python.org/packages/py2.py3/w/wheel/wheel-0.29.0-py2.py3-none-any.whl";
    sha256 = "ea8033fc9905804e652f75474d33410a07404c1a78dd3c949a66863bd1050ebd";
  };
  setuptools_source = fetchurl {
    url = "https://files.pythonhosted.org/packages/3b/7e/293d19ccd106119e35db4bf3e111b1895098f618b455b758aa636496cf03/setuptools-28.8.0-py2.py3-none-any.whl";
    sha256 = "2e59d06ac798efce29c567ee0e0687514efca529a665b8f364cf497cd10d21b2";
  };
  argparse_source = fetchurl {
    url = "https://pypi.python.org/packages/2.7/a/argparse/argparse-1.4.0-py2.py3-none-any.whl";
    sha256 = "0533cr5w14da8wdb2q4py6aizvbvsdbk3sj7m1jx9lwznvnlf5n3";
  };
in stdenv.mkDerivation rec {
  name = "${python.libPrefix}-bootstrapped-pip-${version}";
  version = "9.0.1";

  src = fetchurl {
    url = "https://files.pythonhosted.org/packages/b6/ac/7015eb97dc749283ffdec1c3a88ddb8ae03b8fad0f0e611408f196358da3/pip-9.0.1-py2.py3-none-any.whl";
    sha256 = "690b762c0a8460c303c089d5d0be034fb15a5ea2b75bdf565f40421f542fefb0";
  };

  unpackPhase = ''
    mkdir -p $out/${python.sitePackages}
    unzip -d $out/${python.sitePackages} $src
    unzip -d $out/${python.sitePackages} ${setuptools_source}
    unzip -d $out/${python.sitePackages} ${wheel_source}
  '' + stdenv.lib.optionalString (python.isPy26 or false) ''
    unzip -d $out/${python.sitePackages} ${argparse_source}
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
