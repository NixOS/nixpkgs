{
  abseil-cpp,
  bzip2,
  cbc,
  cmake,
  DarwinTools, # sw_vers
  eigen,
  ensureNewerSourcesForZipFilesHook,
  fetchFromGitHub,
  fetchpatch,
  glpk,
  highs,
  lib,
  pkg-config,
  protobuf,
  python,
  re2,
  stdenv,
  swig,
  unzip,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "or-tools";
  version = "9.12";

  src = fetchFromGitHub {
    owner = "google";
    repo = "or-tools";
    tag = "v${version}";
    hash = "sha256-5rFeAK51+BfjIyu/5f5ptaKMD7Hd20yHa2Vj3O3PkLU=";
  };

  patches = [
    # Rebased from https://build.opensuse.org/public/source/science/google-or-tools/0001-Do-not-try-to-copy-pybind11_abseil-status-extension-.patch?rev=19
    ./0001-Do-not-try-to-copy-pybind11_abseil-status-extension-.patch
    (fetchpatch {
      name = "0001-Revert-python-Fix-python-install-on-windows-breaks-L.patch";
      url = "https://build.opensuse.org/public/source/science/google-or-tools/0001-Revert-python-Fix-python-install-on-windows-breaks-L.patch?rev=19";
      hash = "sha256-BNB3KlgjpWcZtb9e68Jkc/4xC4K0c+Iisw0eS6ltYXE=";
    })
    (fetchpatch {
      name = "0001-Fix-up-broken-CMake-rules-for-bundled-pybind-stuff.patch";
      url = "https://build.opensuse.org/public/source/science/google-or-tools/0001-Fix-up-broken-CMake-rules-for-bundled-pybind-stuff.patch?rev=19";
      hash = "sha256-r38ZbRkEW1ZvJb0Uf56c0+HcnfouZZJeEYlIK7quSjQ=";
    })
  ];

  # or-tools normally attempts to build Protobuf for the build platform when
  # cross-compiling. Instead, just tell it where to find protoc.
  postPatch =
    ''
      echo "set(PROTOC_PRG $(type -p protoc))" > cmake/host.cmake
    ''
    # Patches from OpenSUSE:
    # https://build.opensuse.org/projects/science/packages/google-or-tools/files/google-or-tools.spec?expand=1
    + ''
      sed -i -e '/CMAKE_DEPENDENT_OPTION(INSTALL_DOC/ s/BUILD_CXX AND BUILD_DOC/BUILD_CXX/' CMakeLists.txt
      find . -iname \*CMakeLists.txt -exec sed -i -e 's/pybind11_native_proto_caster/pybind11_protobuf::pybind11_native_proto_caster/' '{}' \;
      sed -i -e 's/TARGET pybind11_native_proto_caster/TARGET pybind11_protobuf::pybind11_native_proto_caster/' cmake/check_deps.cmake
      sed -i -e "/protobuf/ { s/.*,/'protobuf >= 5.26',/ }" ortools/python/setup.py.in
    '';

  cmakeFlags = [
    "-DBUILD_DEPS=OFF"
    "-DBUILD_PYTHON=ON"
    "-DBUILD_pybind11=OFF"
    "-DCMAKE_INSTALL_BINDIR=bin"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DFETCH_PYTHON_DEPS=OFF"
    "-DUSE_GLPK=ON"
    "-DUSE_SCIP=OFF"
    "-DPython3_EXECUTABLE=${python.pythonOnBuildForHost.interpreter}"
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ "-DCMAKE_MACOSX_RPATH=OFF" ];

  strictDeps = true;

  nativeBuildInputs =
    [
      cmake
      ensureNewerSourcesForZipFilesHook
      pkg-config
      python.pythonOnBuildForHost
      swig
      unzip
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      DarwinTools
    ]
    ++ (with python.pythonOnBuildForHost.pkgs; [
      pip
      mypy-protobuf
      mypy
    ]);
  buildInputs = [
    abseil-cpp
    bzip2
    cbc
    eigen
    glpk
    python.pkgs.absl-py
    python.pkgs.pybind11
    python.pkgs.pybind11-abseil
    python.pkgs.pybind11-protobuf
    python.pkgs.pytest
    python.pkgs.scipy
    python.pkgs.setuptools
    python.pkgs.wheel
    re2
    zlib
  ];
  propagatedBuildInputs = [
    abseil-cpp
    highs
    protobuf
    (python.pkgs.protobuf.override { protobuf = protobuf; })
    python.pkgs.numpy
    python.pkgs.pandas
    python.pkgs.immutabledict
  ];
  nativeCheckInputs = [
    python.pkgs.matplotlib
    python.pkgs.virtualenv
  ];

  # some tests fail on linux and hang on darwin
  doCheck = false;

  preCheck = ''
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH''${LD_LIBRARY_PATH:+:}$PWD/lib
  '';

  # This extra configure step prevents the installer from littering
  # $out/bin with sample programs that only really function as tests,
  # and disables the upstream installation of a zipped Python egg that
  # can’t be imported with our Python setup.
  installPhase = ''
    cmake . -DBUILD_EXAMPLES=OFF -DBUILD_PYTHON=OFF -DBUILD_SAMPLES=OFF
    cmake --install .
    pip install --prefix="$python" python/
  '';

  outputs = [
    "out"
    "python"
  ];

  meta = with lib; {
    homepage = "https://github.com/google/or-tools";
    license = licenses.asl20;
    description = ''
      Google's software suite for combinatorial optimization.
    '';
    mainProgram = "fzn-cp-sat";
    maintainers = with maintainers; [ andersk ];
    platforms = with platforms; linux ++ darwin;
  };
}
