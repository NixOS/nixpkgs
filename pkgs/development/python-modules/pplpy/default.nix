{
  lib,
  fetchPypi,
  buildPythonPackage,
  python,
  pkg-config,
  gmp,
  mpfr,
  libmpc,
  ppl,
  cython,
  meson-python,
  cysignals,
  gmpy2,
  sphinx,

  # Reverse dependency
  sage,
}:

buildPythonPackage rec {
  pname = "pplpy";
  version = "0.9.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-gonFDWgM4/nqysZmy0zbvYpxGVnnzHzwb3/bQDXQzF0=";
  };

  postPatch = ''
    # gmpy2 < 2.3 truncates instead of rounding when converting mpq to float.
    # Remove once gmpy2 >= 2.3.
    substituteInPlace ppl/mip_problem.pyx \
      --replace-fail "3.3333333333333335" "3.33333333333333..."
  '';

  buildInputs = [
    gmp
    mpfr
    libmpc
    ppl
  ];

  build-system = [
    cython
    meson-python
  ];

  nativeBuildInputs = [
    pkg-config
    ppl # ppl-config, used by meson to locate ppl
    sphinx # docbuild, called by make
  ];

  dependencies = [
    cysignals
    gmpy2
  ];

  outputs = [
    "out"
    "doc"
  ];

  postInstall = ''
    # The doc build needs to import pplpy.
    echo "Building documentation"
    PYTHONPATH="$out/${python.sitePackages}:$PYTHONPATH" make -C docs html

    mkdir -p "$doc/share/doc"
    mv docs/build/html "$doc/share/doc/pplpy"
  '';

  pythonImportsCheck = [ "ppl" ];

  checkPhase = ''
    runHook preCheck

    PYTHONPATH="$out/${python.sitePackages}:$PYTHONPATH" ${python.interpreter} tests/runtests.py

    runHook postCheck
  '';

  passthru.tests = {
    inherit sage;
  };

  meta = {
    description = "Python wrapper for ppl";
    homepage = "https://gitlab.com/videlec/pplpy";
    teams = [ lib.teams.sage ];
    license = lib.licenses.gpl3;
  };
}
