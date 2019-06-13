{ lib
, python
, fetchPypi
, buildPythonPackage
, gmp
, mpfr
, libmpc
, ppl
, pari
, cython
, cysignals
, gmpy2
, sphinx
}:

buildPythonPackage rec {
  pname = "pplpy";
  version = "0.8.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0dk8l5r3f2jbkkasddvxwvhlq35pjsiirh801lrapv8lb16r2qmr";
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
    homepage = https://gitlab.com/videlec/pplpy;
    maintainers = with maintainers; [ timokau ];
    license = licenses.gpl3;
  };
}
