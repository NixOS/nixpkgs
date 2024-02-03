{ buildPythonPackage
, SDL2
, cmake
, fetchFromGitHub
, fetchpatch
, gym
, importlib-metadata
, importlib-resources
, lib
, ninja
, numpy
, pybind11
, pytestCheckHook
, pythonOlder
, setuptools
, stdenv
, typing-extensions
, wheel
, zlib
}:

buildPythonPackage rec {
  pname = "ale-py";
  version = "0.8.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Farama-Foundation";
    repo = "Arcade-Learning-Environment";
    rev = "refs/tags/v${version}";
    hash = "sha256-B2AxhlzvBy1lJ3JttJjImgTjMtEUyZBv+xHU2IC7BVE=";
  };

  patches = [
    # don't download pybind11, use local pybind11
    ./cmake-pybind11.patch
    ./patch-sha-check-in-setup.patch

    # The following two patches add the required `include <cstdint>` for compilation to work with GCC 13.
    # See https://github.com/Farama-Foundation/Arcade-Learning-Environment/pull/503
    (fetchpatch {
      name = "fix-gcc13-compilation-1";
      url = "https://github.com/Farama-Foundation/Arcade-Learning-Environment/commit/ebd64c03cdaa3d8df7da7c62ec3ae5795105e27a.patch";
      hash = "sha256-NMz0hw8USOj88WryHRkMQNWznnP6+5aWovEYNuocQ2c=";
    })
    (fetchpatch {
      name = "fix-gcc13-compilation-2";
      url = "https://github.com/Farama-Foundation/Arcade-Learning-Environment/commit/4c99c7034f17810f3ff6c27436bfc3b40d08da21.patch";
      hash = "sha256-66/bDCyMr1RsKk63T9GnFZGloLlkdr/bf5WHtWbX6VY=";
    })
  ];

  nativeBuildInputs = [
    cmake
    ninja
    setuptools
    wheel
    pybind11
  ];

  buildInputs = [
    zlib
    SDL2
  ];

  propagatedBuildInputs = [
    typing-extensions
    importlib-resources
    numpy
  ] ++ lib.optionals (pythonOlder "3.10") [
    importlib-metadata
  ];

  nativeCheckInputs = [
    pytestCheckHook
    gym
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'dynamic = ["version"]' 'version = "${version}"'
    substituteInPlace setup.py \
      --replace '@sha@' '"${version}"'
  '';

  dontUseCmakeConfigure = true;

  pythonImportsCheck = [ "ale_py" ];

  meta = with lib; {
    description = "a simple framework that allows researchers and hobbyists to develop AI agents for Atari 2600 games";
    homepage = "https://github.com/mgbellemare/Arcade-Learning-Environment";
    license = licenses.gpl2;
    maintainers = with maintainers; [ billhuang ];
    broken = stdenv.isDarwin; # fails to link with missing library
  };
}
