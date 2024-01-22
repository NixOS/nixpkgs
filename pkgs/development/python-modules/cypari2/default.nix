{ lib
, buildPythonPackage
, python
, fetchpatch
, fetchPypi
, pari
, gmp
, cython
, cysignals
}:

buildPythonPackage rec {
  pname = "cypari2";
  # upgrade may break sage, please test the sage build or ping @timokau on upgrade
  version = "2.1.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "17beb467d3cb39fffec3227c468f0dd8db8a09129faeb95a6bb4c84b2b6c6683";
  };

  patches = [
    # patch to avoid some segfaults in sage's totallyreal.pyx test.
    # (https://trac.sagemath.org/ticket/27267). depends on Cython patch.
    (fetchpatch {
      name = "use-trashcan-for-gen.patch";
      url = "https://raw.githubusercontent.com/sagemath/sage/b6ea17ef8e4d652de0a85047bac8d41e90b25555/build/pkgs/cypari/patches/trashcan.patch";
      hash = "sha256-w4kktWb9/aR9z4CjrUvAMOxEwRN2WkubaKzQttN8rU8=";
    })
  ];

  preBuild = ''
    # generate cythonized extensions (auto_paridecl.pxd is crucial)
    ${python.pythonOnBuildForHost.interpreter} setup.py build_ext --inplace
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
    test -f "$out/${python.sitePackages}/cypari2/auto_paridecl.pxd"
    make check
  '';

  meta = with lib; {
    description = "Cython bindings for PARI";
    license = licenses.gpl2Plus;
    maintainers = teams.sage.members;
    homepage = "https://github.com/defeo/cypari2";
  };
}
