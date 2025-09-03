{
  lib,
  fetchPypi,
  buildPythonPackage,
  gmp,
  mpfr,
  libmpc,
  ppl,
  cython,
  cysignals,
  gmpy2,
  sphinx,

  # Reverse dependency
  sage,
}:

buildPythonPackage rec {
  pname = "pplpy";
  version = "0.8.10";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-1CohbIKRTc9NfAAN68mLsza4+D4Ca6XZUszNn4B07/0=";
  };

  buildInputs = [
    gmp
    mpfr
    libmpc
    ppl
  ];

  nativeBuildInputs = [
    sphinx # docbuild, called by make
  ];

  propagatedBuildInputs = [
    cython
    cysignals
    gmpy2
  ];

  outputs = [
    "out"
    "doc"
  ];

  postBuild = ''
    # Find the build result in order to put it into PYTHONPATH. The doc
    # build needs to import pplpy.
    build_result="$PWD/$( find build/ -type d -name 'lib.*' | head -n1 )"

    echo "Building documentation"
    PYTHONPATH="$build_result:$PYTHONPATH" make -C docs html
  '';

  postInstall = ''
    mkdir -p "$doc/share/doc"
    mv docs/build/html "$doc/share/doc/pplpy"
  '';

  passthru.tests = {
    inherit sage;
  };

  meta = with lib; {
    description = "Python wrapper for ppl";
    homepage = "https://gitlab.com/videlec/pplpy";
    teams = [ teams.sage ];
    license = licenses.gpl3;
  };
}
