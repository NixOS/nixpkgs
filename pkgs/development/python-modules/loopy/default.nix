{ lib
, buildPythonPackage
, codepy
, cgen
, colorama
, fetchFromGitHub
, genpy
, islpy
, mako
, numpy
, pymbolic
, pyopencl
, pyrsistent
, pythonOlder
, pytools
}:

buildPythonPackage rec {
  pname = "loopy";
  version = "2024.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "inducer";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-R0Wry4r8Y7VKqsyrZ3odEOUy4T9di9rFQzq7BD0LG58=";
  };

  propagatedBuildInputs = [
    codepy
    cgen
    colorama
    genpy
    islpy
    mako
    numpy
    pymbolic
    pyopencl
    pyrsistent
    pytools
  ];

  # pyopencl._cl.LogicError: clGetPlatformIDs failed: PLATFORM_NOT_FOUND_KHR
  doCheck = false;

  meta = with lib; {
    description = "A code generator for array-based code on CPUs and GPUs";
    homepage = "https://github.com/inducer/loopy";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
