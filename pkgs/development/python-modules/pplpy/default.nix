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
  version = "0.8.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "500bd0f4ae1a76956fae7fcba77854f5ec3e64fce76803664983763c3f2bd8bd";
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
