{
  abseil-cpp,
  bzip2,
  cbc,
  cmake,
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
  swig4,
  unzip,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "or-tools";
  version = "9.4";

  src = fetchFromGitHub {
    owner = "google";
    repo = "or-tools";
    rev = "v${version}";
    sha256 = "sha256-joWonJGuxlgHhXLznRhC1MDltQulXzpo4Do9dec1bLY=";
  };
  patches = [
    # Disable test that requires external input: https://github.com/google/or-tools/issues/3429
    (fetchpatch {
      url = "https://github.com/google/or-tools/commit/7072ae92ec204afcbfce17d5360a5884c136ce90.patch";
      hash = "sha256-iWE+atp308q7pC1L1FD6sK8LvWchZ3ofxvXssguozbM=";
    })
    # Fix test that broke in parallel builds: https://github.com/google/or-tools/issues/3461
    (fetchpatch {
      url = "https://github.com/google/or-tools/commit/a26602f24781e7bfcc39612568aa9f4010bb9736.patch";
      hash = "sha256-gM0rW0xRXMYaCwltPK0ih5mdo3HtX6mKltJDHe4gbLc=";
    })
    # Backport fix in cmake test configuration where pip installs newer version from PyPi over local build,
    #  breaking checkPhase: https://github.com/google/or-tools/issues/3260
    (fetchpatch {
      url = "https://github.com/google/or-tools/commit/edd1544375bd55f79168db315151a48faa548fa0.patch";
      hash = "sha256-S//1YM3IoRCp3Ghg8zMF0XXgIpVmaw4gH8cVb9eUbqM=";
    })
    # Don't use non-existent member of string_view. Partial patch from commit
    # https://github.com/google/or-tools/commit/c5a2fa1eb673bf652cb9ad4f5049d054b8166e17.patch
    ./fix-stringview-compile.patch
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
    "-DFETCH_PYTHON_DEPS=OFF"
    "-DUSE_GLPK=ON"
    "-DUSE_SCIP=OFF"
    "-DPython3_EXECUTABLE=${python.pythonOnBuildForHost.interpreter}"
  ] ++ lib.optionals stdenv.isDarwin [ "-DCMAKE_MACOSX_RPATH=OFF" ];
  nativeBuildInputs =
    [
      cmake
      ensureNewerSourcesForZipFilesHook
      pkg-config
      python.pythonOnBuildForHost
      swig4
      unzip
    ]
    ++ (with python.pythonOnBuildForHost.pkgs; [
      pip
      mypy-protobuf
    ]);
  buildInputs = [
    bzip2
    cbc
    eigen
    glpk
    python.pkgs.absl-py
    python.pkgs.pybind11
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

  doCheck = true;

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
    mainProgram = "fzn-ortools";
    maintainers = with maintainers; [ andersk ];
    platforms = with platforms; linux ++ darwin;
  };
}
