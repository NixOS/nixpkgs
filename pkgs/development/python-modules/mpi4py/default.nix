{ stdenv, fetchPypi, python, buildPythonPackage, mpi, openssh, isPy3k, isPyPy }:

buildPythonPackage rec {
  pname = "mpi4py";
  version = "2.0.0";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "10fb01595rg17ycz08a23v24akm25d13srsy2rnixam7a5ca0hv5";
  };

  passthru = {
    inherit mpi;
  };

  # Rename libm.so -> libm.so.6 in test
  # See: https://bitbucket.org/mpi4py/mpi4py/issues/28/test_dltestdl-test-failure
  patches = [
    ./tests.patch
  ];

  # The tests in the `test_spawn` module fail in the chroot build environment.
  # However, they do pass in a pure, or non-pure nix-shell. Hence, we
  # deactivate these particular tests.
  # Unfortunately, the command-line arguments to `./setup.py test` are not
  # correctly passed to the test-runner. Hence, these arguments are patched
  # directly into `setup.py`.
  prePatch = ''
    sed 's/err = main(cmd.args or \[\])/err = main(cmd.args or ["-v", "-e", "test_spawn"])/' -i setup.py
  '';

  configurePhase = "";

  installPhase = ''
    mkdir -p "$out/lib/${python.libPrefix}/site-packages"
    export PYTHONPATH="$out/lib/${python.libPrefix}/site-packages:$PYTHONPATH"

    ${python}/bin/${python.executable} setup.py install \
      --install-lib=$out/lib/${python.libPrefix}/site-packages \
      --prefix="$out"

    # --install-lib:
    # sometimes packages specify where files should be installed outside the usual
    # python lib prefix, we override that back so all infrastructure (setup hooks)
    # work as expected
  '';

  setupPyBuildFlags = ["--mpicc=${mpi}/bin/mpicc"];

  buildInputs = [ mpi ];
  # Requires openssh for tests. Tests of dependent packages will also fail,
  # if openssh is not present. E.g. h5py with mpi support.
  propagatedBuildInputs = [ openssh ];

  disabled = isPy3k || isPyPy;

  # Timing out communicating between processes when sandboxing enabled.
  doCheck = false;

  meta = {
    description =
      "Python bindings for the Message Passing Interface standard";
    homepage = http://code.google.com/p/mpi4py/;
    license = stdenv.lib.licenses.bsd3;
  };
}
