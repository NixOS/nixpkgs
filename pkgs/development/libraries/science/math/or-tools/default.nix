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
  version = "9.9";

  src = fetchFromGitHub {
    owner = "google";
    repo = "or-tools";
    rev = "v${version}";
    hash = "sha256-Ip2mKl+MuzOPaF1a2FTubqT0tA4gzDnD8dR7dLaHHo8=";
  };

  patches = [
    (fetchpatch {
      name = "0001-Allow-to-use-pybind11-system-packages.patch";
      url = "https://build.opensuse.org/public/source/science/google-or-tools/0001-Allow-to-use-pybind11-system-packages.patch?rev=18";
      hash = "sha256-+hFgZt9G0EMpMMXA/qnHjOdk6+eIlgV6T0qu36s4Z/Y=";
    })
    (fetchpatch {
      name = "0001-Do-not-try-to-copy-pybind11_abseil-status-extension-.patch";
      url = "https://build.opensuse.org/public/source/science/google-or-tools/0001-Do-not-try-to-copy-pybind11_abseil-status-extension-.patch?rev=18";
      hash = "sha256-vAjxUW1SjHRG2mpyjHjrAkyoix1BnGCxzvFDMzRp3Bk=";
    })
  ];

  # or-tools normally attempts to build Protobuf for the build platform when
  # cross-compiling. Instead, just tell it where to find protoc.
  postPatch = ''
    echo "set(PROTOC_PRG $(type -p protoc))" > cmake/host.cmake
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
    protobuf
    (python.pkgs.protobuf4.override { protobuf = protobuf; })
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
