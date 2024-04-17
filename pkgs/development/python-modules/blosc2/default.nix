{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch

# build-system
, cmake
, cython
, ninja
, oldest-supported-numpy
, scikit-build
, setuptools
, wheel

# propagates
, msgpack
, ndindex
, numpy
, py-cpuinfo
, rich

# tests
, psutil
, pytestCheckHook
, torch
}:

buildPythonPackage rec {
  pname = "blosc2";
  version = "2.2.7";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "Blosc";
    repo = "python-blosc2";
    rev = "refs/tags/v${version}";
    fetchSubmodules = true;
    hash = "sha256-5a94Zm6sYl/nSfkcFbKG7PkyXwLB6bAoIvfaq0yVGHo=";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2024-3203.CVE-2024-3204.part-1.patch";
      url = "https://github.com/Blosc/c-blosc2/commit/892f6d9c8ffc6e3c4d571df8fc02114f88c69b52.patch";
      stripLen = 1;
      extraPrefix = "blosc2/c-blosc2/";
      hash = "sha256-sNgDcdT9HFrx41VKohp4GNUEjM1sqLYkIZu4baKRMeI=";
    })
    (fetchpatch {
      name = "CVE-2024-3203.CVE-2024-3204.part-2.patch";
      url = "https://github.com/Blosc/c-blosc2/commit/9cc79a79373f1b338b2e029e2e489b4e7971cd0c.patch";
      stripLen = 1;
      extraPrefix = "blosc2/c-blosc2/";
      hash = "sha256-J/zcyNrxQr43+ROhDDQFmUJZQSTwo9qDuLwZeLd/ooo=";
    })
  ];

  postPatch = ''
    substituteInPlace requirements-runtime.txt \
      --replace "pytest" ""
  '';

  nativeBuildInputs = [
    cmake
    cython
    ninja
    oldest-supported-numpy
    scikit-build
    setuptools
    wheel
  ];

  dontUseCmakeConfigure = true;

  propagatedBuildInputs = [
    msgpack
    ndindex
    numpy
    py-cpuinfo
    rich
  ];

  nativeCheckInputs = [
    psutil
    pytestCheckHook
    torch
  ];

  meta = with lib; {
    description = "Python wrapper for the extremely fast Blosc2 compression library";
    homepage = "https://github.com/Blosc/python-blosc2";
    changelog = "https://github.com/Blosc/python-blosc2/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
