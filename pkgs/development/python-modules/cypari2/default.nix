{ stdenv
, buildPythonPackage
, python
, fetchPypi
, pari
, gmp
, cython
, cysignals
}:

buildPythonPackage rec {
  pname = "cypari2";
  # upgrade may break sage, please test the sage build or ping @timokau on upgrade
  version = "1.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "04f00xp8aaz37v00iqg1mv5wjq00a5qhk8cqa93s13009s9x984r";
  };

  # This differs slightly from the default python installPhase in that it pip-installs
  # "." instead of "*.whl".
  # That is because while the default install phase succeeds to build the package,
  # it fails to generate the file "auto_paridecl.pxd".
  installPhase = ''
    mkdir -p "$out/lib/${python.sitePackages}"
    export PYTHONPATH="$out/lib/${python.sitePackages}:$PYTHONPATH"

    # install "." instead of "*.whl"
    ${python.pythonForBuild.pkgs.bootstrapped-pip}/bin/pip install --no-index --prefix=$out --no-cache --build=tmpdir .
  '';

  buildInputs = [
    pari
    gmp
  ];

  propagatedBuildInputs = [
    cysignals
    cython
  ];

  checkPhase = ''
    make check
  '';

  meta = with stdenv.lib; {
    description = "Cython bindings for PARI";
    license = licenses.gpl2;
    maintainers = with maintainers; [ timokau ];
    homepage = https://github.com/defeo/cypari2;
  };
}
