{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  cmake,
  eigen,
  ninja,
  scikit-build,
  pytestCheckHook,
  numpy,
  scipy,
  torch,
  jax,
  jaxlib,
  tensorflow,
  setuptools,
}:
buildPythonPackage rec {
  pname = "nanobind";
  version = "1.9.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "wjakob";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-6swDqw7sEYOawQbNWD8VfSQoi+9wjhOhOOwPPkahDas=";
    fetchSubmodules = true;
  };

  disabled = pythonOlder "3.8";

  nativeBuildInputs = [
    cmake
    ninja
    scikit-build
    setuptools
  ];
  buildInputs = [ eigen ];
  dontUseCmakeBuildDir = true;

  preCheck = ''
    # build tests
    make -j $NIX_BUILD_CORES
  '';

  nativeCheckInputs = [
    pytestCheckHook
    numpy
    scipy
    torch
    tensorflow
    # Uncomment at next release (1.9.3)
    # See https://github.com/wjakob/nanobind/issues/578
    # jax
    # jaxlib
  ];

  meta = with lib; {
    homepage = "https://github.com/wjakob/nanobind";
    changelog = "https://github.com/wjakob/nanobind/blob/${src.rev}/docs/changelog.rst";
    description = "Tiny and efficient C++/Python bindings";
    longDescription = ''
      nanobind is a small binding library that exposes C++ types in Python and
      vice versa. It is reminiscent of Boost.Python and pybind11 and uses
      near-identical syntax. In contrast to these existing tools, nanobind is
      more efficient: bindings compile in a shorter amount of time, produce
      smaller binaries, and have better runtime performance.
    '';
    license = licenses.bsd3;
    maintainers = with maintainers; [ parras ];
  };
}
