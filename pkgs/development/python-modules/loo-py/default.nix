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
  version = "2020.2";

  src = fetchPypi {
    pname = "loo.py";
    inherit version;
    sha256 = "c0aba31f8b61f6487e84120a154fab862d19c3b374ad4285b987c4f2d746d51f";
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
