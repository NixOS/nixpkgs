{ stdenv
, buildPythonPackage
, fetchPypi
, cmake
, numpy
, scipy
, scikitlearn
, llvmPackages ? null
}:

buildPythonPackage rec {
  pname = "lightgbm";
  version = "3.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "05f5b358469a679dbf27521d926750ca53ff1e61a6c0293d49af30094ebd9d4a";
  };

  nativeBuildInputs = [
    cmake
  ];

  dontUseCmakeConfigure = true;

  # we never actually explicitly call the install command so this is the only way
  # to inject these options to it - however, openmp-library doesn't appear to have
  # any effect, so we have to inject it into NIX_LDFLAGS manually below
  postPatch = stdenv.lib.optionalString stdenv.cc.isClang ''
    cat >> setup.cfg <<EOF

    [install]
    openmp-include-dir=${llvmPackages.openmp}/include
    openmp-library=${llvmPackages.openmp}/lib/libomp.dylib

    EOF
  '';

  propagatedBuildInputs = [
    numpy
    scipy
    scikitlearn
  ];

  postConfigure = ''
    export HOME=$(mktemp -d)
  '' + stdenv.lib.optionalString stdenv.cc.isClang ''
    export NIX_LDFLAGS="$NIX_LDFLAGS -L${llvmPackages.openmp}/lib -lomp"
  '';

  # The pypi package doesn't distribute the tests from the GitHub
  # repository. It contains c++ tests which don't seem to wired up to
  # `make check`.
  doCheck = false;

  meta = with stdenv.lib; {
    description = "A fast, distributed, high performance gradient boosting (GBDT, GBRT, GBM or MART) framework";
    homepage = "https://github.com/Microsoft/LightGBM";
    license = licenses.mit;
    maintainers = with maintainers; [ teh costrouc ];
  };
}
