{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchurl
, cmake
, setuptools-scm
, scikit-build
, pytestCheckHook
, pytest-virtualenv
}:
let
  # these must match NinjaUrls.cmake
  ninja_src_url = "https://github.com/Kitware/ninja/archive/v1.11.1.g95dee.kitware.jobserver-1.tar.gz";
  ninja_src_sha256 = "7ba84551f5b315b4270dc7c51adef5dff83a2154a3665a6c9744245c122dd0db";
  ninja_src = fetchurl {
    url = ninja_src_url;
    sha256 = ninja_src_sha256;
  };
in
buildPythonPackage rec {
  pname = "ninja";
  version = "1.11.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "scikit-build";
    repo = "ninja-python-distributions";
    rev = version;
    hash = "sha256-scCYsSEyN+u3qZhNhWYqHpJCl+JVJJbKz+T34gOXGJM=";
  };
  patches = [
    # make sure cmake doesn't try to download the ninja sources
    ./no-download.patch
  ];

  inherit ninja_src;
  postUnpack = ''
    # assume that if the hash matches, the source should be fine
    if ! grep "${ninja_src_sha256}" $sourceRoot/NinjaUrls.cmake; then
      echo "ninja_src_sha256 doesn't match the hash in NinjaUrls.cmake!"
      exit 1
    fi
    mkdir -p "$sourceRoot/Ninja-src"
    pushd "$sourceRoot/Ninja-src"
    tar -xavf ${ninja_src} --strip-components 1
    popd
  '';

  postPatch = ''
    sed -i '/cov/d' setup.cfg
  '';

  dontUseCmakeConfigure = true;

  nativeBuildInputs = [
    setuptools-scm
    scikit-build
    cmake
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-virtualenv
  ];

  meta = with lib; {
    description = "A small build system with a focus on speed";
    homepage = "https://github.com/scikit-build/ninja-python-distributions";
    license = licenses.asl20;
    maintainers = with maintainers; [ _999eagle ];
  };
}
