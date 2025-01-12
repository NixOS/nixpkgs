{
  lib,
  buildPythonPackage,
  python,
  fetchPypi,
  pari,
  gmp,
  cython,
  cysignals,

  # Reverse dependency
  sage,
}:

buildPythonPackage rec {
  pname = "cypari2";
  # upgrade may break sage, please test the sage build or ping @timokau on upgrade
  version = "2.2.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-gXYGv2YbcdM+HQEkIZB6T4+wndgbfT464Xmzl4Agu/E=";
  };

  preBuild = ''
    # generate cythonized extensions (auto_paridecl.pxd is crucial)
    ${python.pythonOnBuildForHost.interpreter} setup.py build_ext --inplace
  '';

  nativeBuildInputs = [ pari ];

  buildInputs = [ gmp ];

  propagatedBuildInputs = [
    cysignals
    cython
  ];

  checkPhase = ''
    test -f "$out/${python.sitePackages}/cypari2/auto_paridecl.pxd"
    make check
  '';

  passthru.tests = {
    inherit sage;
  };

  meta = with lib; {
    description = "Cython bindings for PARI";
    license = licenses.gpl2Plus;
    maintainers = teams.sage.members;
    homepage = "https://github.com/defeo/cypari2";
  };
}
