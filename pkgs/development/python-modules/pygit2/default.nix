{ stdenv, lib, buildPythonPackage, fetchPypi, fetchpatch, isPyPy, libgit2_0_27, six, cffi }:

buildPythonPackage rec {
  pname = "pygit2";
  version = "0.27.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0d9bgxd6ch5jxz0j5cmx7c4kw933g8pgm2zxf3id1a6w9g2r7hpw";
  };

  preConfigure = lib.optionalString stdenv.isDarwin ''
    export DYLD_LIBRARY_PATH="${libgit2_0_27}/lib"
  '';

  patches = [ (fetchpatch {
    name = "dont-require-old-pycparser"; # https://github.com/libgit2/pygit2/issues/819
    url = https://github.com/libgit2/pygit2/commit/1eaba181577de206d3d43ec7886d0353fc0c9f2a.patch;
    sha256 = "18x1fpmywhjjr4lvakwmy34zpxfqi8pqqj48g1wcib39lh3s7l4f";
  }) ];

  propagatedBuildInputs = [ libgit2_0_27 six ] ++ lib.optional (!isPyPy) cffi;

  preCheck = ''
    # disable tests that require networking
    rm test/test_repository.py
    rm test/test_credentials.py
    rm test/test_submodule.py
  '';

  meta = with lib; {
    description = "A set of Python bindings to the libgit2 shared library";
    homepage = https://pypi.python.org/pypi/pygit2;
    license = licenses.gpl2;
  };
}
