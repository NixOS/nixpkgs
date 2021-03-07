{ lib
, fetchpatch
, fetchPypi
, buildPythonPackage
, cython
, pariSupport ? true, pari # for interfacing with the PARI/GP signal handler
}:

assert pariSupport -> pari != null;

buildPythonPackage rec {
  pname = "cysignals";
  version = "1.10.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1ckxzch3wk5cg80mppky5jib5z4fzslny3001r5zg4ar1ixbc1w1";
  };

  patches = [
    # fixes intermittent crashes in Sage tests (including in interfaces/singular.py)
    # will be included in cysignals 1.10.3: https://github.com/sagemath/cysignals/pull/127
    (fetchpatch {
      name = "fix-verify_exc_value.patch";
      url = "https://github.com/sagemath/cysignals/commit/49a7eee4bba3ab8f340cf56c371fa4f5ed702dcc.patch";
      sha256 = "sha256-Pfc5tL9VDSP6ftDoHoIb+MDi5rjYqr0PRfIajFuuYVs=";
    })
  ];

  # explicit check:
  # build/src/cysignals/implementation.c:27:2: error: #error "cysignals must be compiled without _FORTIFY_SOURCE"
  hardeningDisable = [
    "fortify"
  ];

  # known failure: https://github.com/sagemath/cysignals/blob/582dbf6a7b0f9ade0abe7a7b8720b7fb32435c3c/testgdb.py#L5
  doCheck = false;
  checkTarget = "check-install";

  preCheck = ''
    # Make sure cysignals-CSI is in PATH
    export PATH="$out/bin:$PATH"
  '';

  propagatedBuildInputs = [
    cython
  ] ++ lib.optionals pariSupport [
    # When cysignals is built with pari, including cysignals into the
    # buildInputs of another python package will cause cython to link against
    # pari.
    pari
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Interrupt and signal handling for Cython";
    homepage = "https://github.com/sagemath/cysignals/";
    maintainers = teams.sage.members;
    license = licenses.lgpl3Plus;
  };
}
