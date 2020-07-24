{ lib
, buildPythonPackage
, fetchPypi
, pytools
, pymbolic
, genpy
, cgen
, islpy
, six
, colorama
, mako
, pyopencl
, pytest
}:

buildPythonPackage rec {
  pname = "loo-py";
  version = "2017.2";

  src = fetchPypi {
    pname = "loo.py";
    inherit version;
    sha256 = "c656992de48b328cdaccd7d1f14eb522b9dd5a1d0d15f54623f4ab18fd219abc";
  };

  checkInputs = [ pytest ];
  propagatedBuildInputs = [
    pytools
    pymbolic
    genpy
    cgen
    islpy
    six
    colorama
    mako
    pyopencl
  ];

  # pyopencl._cl.LogicError: clGetPlatformIDs failed: PLATFORM_NOT_FOUND_KHR
  doCheck = false;
  checkPhase = ''
    HOME=$(mktemp -d) pytest test
  '';

  meta = with lib; {
    description = "A code generator for array-based code on CPUs and GPUs";
    homepage = "https://mathema.tician.de/software/loopy";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
