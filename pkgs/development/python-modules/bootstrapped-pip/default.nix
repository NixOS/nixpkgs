{ stdenv, python, fetchurl, makeWrapper, unzip }:

let
  wheel_source = fetchurl {
    url = "https://pypi.python.org/packages/py2.py3/w/wheel/wheel-0.29.0-py2.py3-none-any.whl";
    sha256 = "ea8033fc9905804e652f75474d33410a07404c1a78dd3c949a66863bd1050ebd";
  };
  setuptools_source = fetchurl {
    url = "https://pypi.python.org/packages/3.5/s/setuptools/setuptools-19.4-py2.py3-none-any.whl";
    sha256 = "0801e6d862ca4ce24d918420d62f07ee2fe736dc016e3afa99d2103e7a02e9a6";
  };
  argparse_source = fetchurl {
    url = "https://pypi.python.org/packages/2.7/a/argparse/argparse-1.4.0-py2.py3-none-any.whl";
    sha256 = "0533cr5w14da8wdb2q4py6aizvbvsdbk3sj7m1jx9lwznvnlf5n3";
  };
in stdenv.mkDerivation rec {
  name = "python-${python.version}-bootstrapped-pip-${version}";
  version = "8.1.2";

  src = fetchurl {
    url = "https://pypi.python.org/packages/9c/32/004ce0852e0a127f07f358b715015763273799bd798956fa930814b60f39/pip-${version}-py2.py3-none-any.whl";
    sha256 = "18cjrd66mn4a0gwa99zzs89lrb0xn4xmajdzya6zqd7v16cdsr34";
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
