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
  version = "2.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "03cd45edab8716ebbfdb754e65fea72e873c73dc91aec098fe4a01e35324ac7a";
  };

  patches = [
    # patch to avoid some segfaults in sage's totallyreal.pyx test.
    # (https://trac.sagemath.org/ticket/27267). depends on Cython patch.
    (fetchpatch {
      name = "use-trashcan-for-gen.patch";
      url = "https://git.sagemath.org/sage.git/plain/build/pkgs/cypari/patches/trashcan.patch?id=b6ea17ef8e4d652de0a85047bac8d41e90b25555";
      sha256 = "sha256-w4kktWb9/aR9z4CjrUvAMOxEwRN2WkubaKzQttN8rU8=";
    })
  ];

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

  meta = with lib; {
    description = "Cython bindings for PARI";
    license = licenses.gpl2Plus;
    maintainers = teams.sage.members;
    homepage = "https://github.com/defeo/cypari2";
  };
}
