{ stdenv
, bootstrapped-pip
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
  version = "2.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0yj2wym78g7cl5w6cf2k405zg2116i9h8iqv8fnd7pqphakxh4im";
  };

  # This differs slightly from the default python installPhase in that it pip-installs
  # "." instead of "*.whl".
  # That is because while the default install phase succeeds to build the package,
  # it fails to generate the file "auto_paridecl.pxd".
  installPhase = ''
    mkdir -p "$out/lib/${python.libPrefix}/site-packages"
    export PYTHONPATH="$out/lib/${python.libPrefix}/site-packages:$PYTHONPATH"

    # install "." instead of "*.whl"
    ${bootstrapped-pip}/bin/pip install --no-index --prefix=$out --no-cache --build=tmpdir .
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
