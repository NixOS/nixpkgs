{ lib
, buildPythonPackage
, fetchFromGitHub
, stdenv
, cmake
, ninja
, pybind11
, scikit-build
, setuptools
, pkg-config
, wheel
, nanobind
, drjit-core
, nanothread
, pkgs
, pytestCheckHook
, python
, robin-map
, xxHash
}:

buildPythonPackage rec {
  pname = "drjit";
  version = "unstable-2023-11-23";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mitsuba-renderer";
    repo = "drjit";
    rev = "82dc821d63da02a2a1428ce2533ed317c051a048";
    hash = "sha256-EH7W007hcavhYrMPWlB2EaW6TKq3bUaDfbC743wZTwY=";
  };

  patches = [
    ./0001-cmake-try-find_package-drjit-core-first.patch
    ./0002-autodiff-link-tsl-xxhash-lz4-directly.patch
    ./0003-cmake-export-the-drjit-python-target-too.patch
    ./0004-cmake-dont-override-install-directories-on-nix.patch
  ];

  # I don't have the energies to fix this mess:
  postPatch = ''
    substituteInPlace drjit/router.py \
      --replace \
        "path.abspath(path.dirname(__file__))" \
        "\"$out\""

    mkdir -p ext/drjit-core/ext/nanothread/ext/cmake-defaults
    cp "${nanothread.src}/ext/cmake-defaults/CMakeLists.txt" ext/drjit-core/ext/nanothread/ext/cmake-defaults/
  '' + (
    let useNanobind = false; in lib.optionalString useNanobind ''
      substituteInPlace ext/drjit-core/ext/nanothread/ext/cmake-defaults/CMakeLists.txt \
        --replace \
          "get_cmake_dir()" \
          "cmake_dir()"
    ''
  );

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    pybind11
    scikit-build
    setuptools
    wheel
  ];

  buildInputs = [
    drjit-core
    nanobind
    robin-map
    xxHash
    pkgs.lz4

    # libatomic, although they do not actually use it
    stdenv.cc.cc.lib
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];


  # resources/generate_stub_files.py attempts writing to ~/.drjit at build
  # time; generate_stub_files is also the reason that cross-compilation is
  # kind of broken upstream
  preConfigure = ''
    export HOME=$TMPDIR
  '';
  dontUseCmakeConfigure = true;

  # Ensure drjit.drjit_ext is imported from $out/${python.sitePackages} and not CWD:
  preCheck = ''
    cd tests
  '';

  # Now that scikit-build is done installing its useless cmake targets into the
  # wheel (transitively, site-packages), we reconfigure and install into $out.
  cmakeFlags = [
    (lib.cmakeBool "CLEANUP_AFTER_SKBUILD" true)
    (lib.cmakeFeature "CMAKE_INSTALL_PREFIX" "${placeholder "out"}")
    (lib.cmakeFeature "CMAKE_INSTALL_LIBDIR" "${placeholder "out"}/lib")
    (lib.cmakeFeature "CMAKE_INSTALL_INCLUDEDIR" "${placeholder "out"}/include")
    (lib.cmakeFeature "CMAKE_INSTALL_DATAROOTDIR" "${placeholder "out"}/share")
  ];
  postInstall = ''
    for skBuildDir in _skbuild/* ; do
        cmake -S . -B "$skBuildDir/cmake-build" $cmakeFlags "''${cmakeFlagsArray[@]}"
        cmake --build "$skBuildDir/cmake-build"
        cmake --install "$skBuildDir/cmake-build"
    done
  '';

  pythonImportsCheck = [
    "drjit"
    "drjit.drjit_ext"
  ];

  meta = with lib; {
    description = "Dr.Jit — A Just-In-Time-Compiler for Differentiable Rendering";
    homepage = "https://github.com/mitsuba-renderer/drjit";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
