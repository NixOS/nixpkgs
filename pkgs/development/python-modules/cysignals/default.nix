{ lib
, fetchPypi
, buildPythonPackage
, cython
, pariSupport ? true, pari # for interfacing with the PARI/GP signal handler
}:

assert pariSupport -> pari != null;

buildPythonPackage rec {
  pname = "cysignals";
  version = "1.9.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "15ix8crpad26cfl1skyg7qajqqfdrm8q5ahhmlfmqi1aw0jqj2g2";
  };

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

  meta = {
    description = "Interrupt and signal handling for Cython";
    homepage = https://github.com/sagemath/cysignals/;
    maintainers = with lib.maintainers; [ timokau ];
    license = lib.licenses.lgpl3Plus;
  };
}
