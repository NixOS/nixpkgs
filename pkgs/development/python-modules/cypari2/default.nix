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
  version = "2.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "df1ef62e771ec36e5a456f5fc8b51bc6745b70f0efdd0c7a30c3f0b5f1fb93db";
  };

  # This differs slightly from the default python installPhase in that it pip-installs
  # "." instead of "*.whl".
  # That is because while the default install phase succeeds to build the package,
  # it fails to generate the file "auto_paridecl.pxd".
  installPhase = ''
    export PYTHONPATH="$out/${python.sitePackages}:$PYTHONPATH"

    # install "." instead of "*.whl"
    ${python.pythonForBuild.pkgs.bootstrapped-pip}/bin/pip install . --no-index --no-warn-script-location --prefix="$out" --no-cache
  '';

  nativeBuildInputs = [
    pari
  ];

  buildInputs = [
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
    maintainers = teams.sage.members;
    homepage = "https://github.com/defeo/cypari2";
  };
}
