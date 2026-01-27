{
  lib,
  buildPythonPackage,
  python,
  fetchPypi,
  pari,
  pkg-config,
  gmp,
  meson-python,
  cython,
  cysignals,

  # Reverse dependency
  sage,
}:

buildPythonPackage rec {
  pname = "cypari2";
  # upgrade may break sage, please test the sage build or ping @timokau on upgrade
  version = "2.2.4";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-+fDplKmgsGRhkyBBHh2cMDFYhH4FW1gILv2t5ayX9hM=";
  };

  preConfigure = ''
    substituteInPlace cypari2/meson.build \
       --replace-fail "'cypari2.py'" "'cypari2.pc'"
    # HACK: remove when Sage migrates to a meson build
    sed  -i '1i # distutils: libraries = gmp pari' cypari2/paridecl.pxd
  '';

  build-system = [
    meson-python
    cython
    cysignals
  ];

  nativeBuildInputs = [
    pari
    pkg-config
  ];

  buildInputs = [
    gmp
    pari
  ];

  checkPhase = ''
    test -f "$out/${python.sitePackages}/cypari2/auto_paridecl.pxd"
    make check
  '';

  passthru.tests = {
    inherit sage;
  };

  meta = {
    description = "Cython bindings for PARI";
    license = lib.licenses.gpl2Plus;
    teams = [ lib.teams.sage ];
    homepage = "https://github.com/defeo/cypari2";
  };
}
