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

  # This differs slightly from the default python installPhase in that it pip-installs
  # "." instead of "*.whl".
  # That is because while the default install phase succeeds to build the package,
  # it fails to generate the file "auto_paridecl.pxd".
  installPhase = ''
    export PYTHONPATH="$out/${python.sitePackages}:$PYTHONPATH"

    # install "." instead of "*.whl"
    pip install . --no-index --no-warn-script-location --prefix="$out" --no-cache
  '';

  nativeBuildInputs = [
    pari
    python.pythonForBuild.pkgs.pip
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

  meta = with lib; {
    description = "Cython bindings for PARI";
    license = licenses.gpl2Plus;
    maintainers = teams.sage.members;
    homepage = "https://github.com/defeo/cypari2";
  };
}
