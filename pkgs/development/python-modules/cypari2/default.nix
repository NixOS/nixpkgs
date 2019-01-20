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
  version = "2.0.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0mghbmilmy34xp1d50xdx76sijqxmpkm2bcgx2v1mdji2ff7n0yc";
  };

  # This differs slightly from the default python installPhase in that it pip-installs
  # "." instead of "*.whl".
  # That is because while the default install phase succeeds to build the package,
  # it fails to generate the file "auto_paridecl.pxd".
  installPhase = ''
    export PYTHONPATH="$out/${python.sitePackages}:$PYTHONPATH"

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
