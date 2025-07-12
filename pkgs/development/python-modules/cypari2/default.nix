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
  version = "2.2.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-E6M4c16iIcEGj4/EFVYb93fYxoclcCvHSVRyZP0JFyA=";
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
    teams = [ teams.sage ];
    homepage = "https://github.com/defeo/cypari2";
  };
}
