{ lib
, fetchPypi
, buildPythonPackage
, gmp
, mpfr
, libmpc
, ppl
, cython
, cysignals
, gmpy2
, sphinx
}:

buildPythonPackage rec {
  pname = "pplpy";
  version = "0.8.9";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-23o7Vx1u8FP3UTeXXpR8OhweRaMLq5Dq8hW05cwVeX4=";
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

  outputs = [ "out" "doc" ];

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

  meta = with lib; {
    description = "A Python wrapper for ppl";
    homepage = "https://gitlab.com/videlec/pplpy";
    maintainers = teams.sage.members;
    license = licenses.gpl3;
  };
}
