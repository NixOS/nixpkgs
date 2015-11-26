{ stdenv, python, fetchurl, makeWrapper, unzip }:

let
  wheel_source = fetchurl {
    url = "https://pypi.python.org/packages/py2.py3/w/wheel/wheel-0.26.0-py2.py3-none-any.whl";
    sha256 = "1sl642ncvipqx0hzypvl5hsiqngy0sib0kq242g4mic7vnid6bn9";
  };
  setuptools_source = fetchurl {
    url = "https://pypi.python.org/packages/3.4/s/setuptools/setuptools-18.2-py2.py3-none-any.whl";
    sha256 = "0jhafl8wmjc8xigl1ib5hqiq9crmipcz0zcga52riymgqbf2bzh4";
  };
in stdenv.mkDerivation rec {
  name = "python-${python.version}-bootstrapped-pip-${version}";
  version = "7.1.2";

  src = fetchurl {
    url = "https://pypi.python.org/packages/py2.py3/p/pip/pip-${version}-py2.py3-none-any.whl";
    sha256 = "133hx6jaspm6hd02gza66lng37l65yficc2y2x1gh16fbhxrilxr";
  };

  unpackPhase = ''
    mkdir -p $out/${python.sitePackages}
    unzip -d $out/${python.sitePackages} $src
    unzip -d $out/${python.sitePackages} ${setuptools_source}
    unzip -d $out/${python.sitePackages} ${wheel_source}
  '';

  patchPhase = ''
    mkdir -p $out/bin

    # patch pip to support "pip install --prefix"
    # https://github.com/pypa/pip/pull/3252
    pushd $out/${python.sitePackages}/
    patch -p1 < ${./pip-7.0.1-prefix.patch}
    popd
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
