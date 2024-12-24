{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  cloudpickle,
  cython,
  hypothesis,
  jinja2,
  numpy,
  nvidia-ml-py,
  psutil,
  pydantic,
  pynvml,
  pytestCheckHook,
  pythonOlder,
  rich,
  setuptools-scm,
  setuptools,
}:

let
  heap-layers-src = fetchFromGitHub {
    owner = "emeryberger";
    repo = "heap-layers";
    name = "Heap-Layers";
    rev = "a2048eae91b531dc5d72be7a194e0b333c06bd4c";
    sha256 = "sha256-vl3z30CBX7hav/DM/UE0EQ9lLxZF48tMJrYMXuSulyA=";
  };

  printf-src = fetchFromGitHub {
    owner = "mpaland";
    repo = "printf";
    name = "printf";
    rev = "v4.0.0";
    sha256 = "sha256-tgLJNJw/dJGQMwCmfkWNBvHB76xZVyyfVVplq7aSJnI=";
  };
in

buildPythonPackage rec {
  pname = "scalene";
  version = "1.5.49";
  pyproject = true;
  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "plasma-umass";
    repo = "scalene";
    rev = "v${version}";
    hash = "sha256-Ivce90+W9NBMQjebj3zCB5eqDJydT8OTPYy4fjbybgI=";
  };

  patches = [
    ./01-manifest-no-git.patch
  ];

  prePatch = ''
    cp -r ${heap-layers-src} vendor/Heap-Layers
    mkdir vendor/printf
    cp ${printf-src}/printf.c vendor/printf/printf.cpp
    cp -r ${printf-src}/* vendor/printf
    sed -i 's/^#define printf printf_/\/\/&/' vendor/printf/printf.h
    sed -i 's/^#define vsnprintf vsnprintf_/\/\/&/' vendor/printf/printf.h
  '';

  nativeBuildInputs = [
    cython
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    cloudpickle
    jinja2
    numpy
    psutil
    pydantic
    pynvml
    rich
  ] ++ lib.optionals stdenv.hostPlatform.isLinux [ nvidia-ml-py ];

  pythonRemoveDeps = [
    "nvidia-ml-py3"
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ "nvidia-ml-py" ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [ pytestCheckHook ];

  checkInputs = [
    hypothesis
    numpy
  ];

  disabledTests = [
    # Flaky -- socket collision
    "test_show_browser"
  ];

  # remove scalene directory to prevent pytest import confusion
  preCheck = ''
    rm -rf scalene
  '';

  pythonImportsCheck = [ "scalene" ];

  meta = with lib; {
    description = "High-resolution, low-overhead CPU, GPU, and memory profiler for Python with AI-powered optimization suggestions";
    homepage = "https://github.com/plasma-umass/scalene";
    changelog = "https://github.com/plasma-umass/scalene/releases/tag/v${version}";
    mainProgram = "scalene";
    license = licenses.asl20;
    maintainers = with maintainers; [ sarahec ];
  };
}
