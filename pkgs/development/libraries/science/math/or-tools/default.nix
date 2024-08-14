{ abseil-cpp
, bzip2
, cbc
, cmake
, DarwinTools # sw_vers
, eigen
, ensureNewerSourcesForZipFilesHook
, fetchFromGitHub
, substituteAll
, glpk
, lib
, pkg-config
, protobuf
, python
, re2
, stdenv
, swig4
, unzip
, zlib
}:

let
  pybind11_protobuf = fetchFromGitHub {
    owner = "pybind";
    repo = "pybind11_protobuf";
    rev = "b713501f1da56d9b76c42f89efd00b97c26c9eac";
    hash = "sha256-f6pzRWextH+7lm1xzyhx98wCIWH3lbhn59gSCcjsBVw=";
  };
in
stdenv.mkDerivation rec {
  pname = "or-tools";
  version = "9.7";

  src = fetchFromGitHub {
    owner = "google";
    repo = "or-tools";
    rev = "v${version}";
    hash = "sha256-eHukf6TbY2dx7iEf8WfwfWsjDEubPtRO02ju0kHtASo=";
  };

  patches = [
    (substituteAll {
      src = ./offline.patch;
      pybind11_protobuf = "../../pybind11_protobuf";
    })
  ];

  # or-tools normally attempts to build Protobuf for the build platform when
  # cross-compiling. Instead, just tell it where to find protoc.
  postPatch = ''
    echo "set(PROTOC_PRG $(type -p protoc))" > cmake/host.cmake

    cp -R ${pybind11_protobuf} pybind11_protobuf
    chmod -R u+w pybind11_protobuf
  '';

  cmakeFlags = [
    "-DBUILD_DEPS=OFF"
    "-DBUILD_PYTHON=ON"
    "-DBUILD_pybind11=OFF"
    "-DBUILD_pybind11_protobuf=ON"
    "-DCMAKE_INSTALL_BINDIR=bin"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DFETCH_PYTHON_DEPS=OFF"
    "-DUSE_GLPK=ON"
    "-DUSE_SCIP=OFF"
    "-DPython3_EXECUTABLE=${python.pythonOnBuildForHost.interpreter}"
  ] ++ lib.optionals stdenv.isDarwin [ "-DCMAKE_MACOSX_RPATH=OFF" ];

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    ensureNewerSourcesForZipFilesHook
    pkg-config
    python.pythonOnBuildForHost
    swig4
    unzip
  ] ++ lib.optionals stdenv.isDarwin [
    DarwinTools
  ] ++ (with python.pythonOnBuildForHost.pkgs; [
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
    python.pkgs.pytest
    python.pkgs.scipy
    python.pkgs.setuptools
    python.pkgs.wheel
    re2
    zlib
  ];
  propagatedBuildInputs = [
    abseil-cpp
    protobuf
    (python.pkgs.protobuf.override { protobuf = protobuf; })
    python.pkgs.numpy
  ];
  nativeCheckInputs = [
    python.pkgs.matplotlib
    python.pkgs.pandas
    python.pkgs.virtualenv
  ];

  env.NIX_CFLAGS_COMPILE = toString [
    # fatal error: 'python/google/protobuf/proto_api.h' file not found
    "-I${protobuf.src}"
    # fatal error: 'pybind11_protobuf/native_proto_caster.h' file not found
    "-I${pybind11_protobuf}"
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

  outputs = [ "out" "python" ];

  meta = with lib; {
    homepage = "https://github.com/google/or-tools";
    license = licenses.asl20;
    description = ''
      Google's software suite for combinatorial optimization.
    '';
    mainProgram = "fzn-ortools";
    maintainers = with maintainers; [ andersk ];
    platforms = with platforms; linux ++ darwin;
  };
}
