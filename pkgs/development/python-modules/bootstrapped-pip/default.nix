{ stdenv, python, fetchurl, makeWrapper, unzip }:

let
  wheel_source = fetchurl {
    url = "https://pypi.python.org/packages/py2.py3/w/wheel/wheel-0.26.0-py2.py3-none-any.whl";
    sha256 = "1sl642ncvipqx0hzypvl5hsiqngy0sib0kq242g4mic7vnid6bn9";
  };
  setuptools_source = fetchurl {
    url = "https://pypi.python.org/packages/3.5/s/setuptools/setuptools-19.4-py2.py3-none-any.whl";
    sha256 = "0801e6d862ca4ce24d918420d62f07ee2fe736dc016e3afa99d2103e7a02e9a6";
  };
in stdenv.mkDerivation rec {
  name = "python-${python.version}-bootstrapped-pip-${version}";
  version = "8.0.2";

  src = fetchurl {
    url = "https://pypi.python.org/packages/py2.py3/p/pip/pip-${version}-py2.py3-none-any.whl";
    sha256 = "249a6f3194be8c2e8cb4d4be3f6fd16a9f1e3336218caffa8e7419e3816f9988";
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
    echo '${python.interpreter} -m pip "$@"' > $out/bin/pip
    chmod +x $out/bin/pip

    # wrap binaries with PYTHONPATH
    for f in $out/bin/*; do
      wrapProgram $f --prefix PYTHONPATH ":" $out/${python.sitePackages}/
    done
  '';
}
