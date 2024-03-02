{ lib, fetchPypi, fetchpatch, python, buildPythonPackage
, mpi, mpiCheckPhaseHook, openssh
}:

buildPythonPackage rec {
  pname = "mpi4py";
  version = "3.1.5";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-pwbnbbklUTXC+10e9Uy097DkrZ4zy62n3idiYgXyoVM=";
  };

  passthru = {
    inherit mpi;
  };

  postPatch = ''
    substituteInPlace test/test_spawn.py --replace \
                      "unittest.skipMPI('openmpi(<3.0.0)')" \
                      "unittest.skipMPI('openmpi')"
  '';

  configurePhase = "";

  installPhase = ''
    mkdir -p "$out/${python.sitePackages}"
    export PYTHONPATH="$out/${python.sitePackages}:$PYTHONPATH"

    ${python}/bin/${python.executable} setup.py install \
      --install-lib=$out/${python.sitePackages} \
      --prefix="$out"

    # --install-lib:
    # sometimes packages specify where files should be installed outside the usual
    # python lib prefix, we override that back so all infrastructure (setup hooks)
    # work as expected
  '';

  nativeBuildInputs = [ mpi ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [ openssh mpiCheckPhaseHook ];

  meta = with lib; {
    description = "Python bindings for the Message Passing Interface standard";
    homepage = "https://github.com/mpi4py/mpi4py";
    license = licenses.bsd2;
  };
}
