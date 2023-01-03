{ abseil-cpp
, bzip2
, cbc
, cmake
, eigen
, ensureNewerSourcesForZipFilesHook
, fetchFromGitHub
, fetchpatch
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
  ];

  cmakeFlags = [
    "-DBUILD_DEPS=OFF"
    "-DBUILD_PYTHON=ON"
    "-DBUILD_pybind11=OFF"
    "-DFETCH_PYTHON_DEPS=OFF"
    "-DUSE_GLPK=ON"
    "-DUSE_SCIP=OFF"
  ];
  nativeBuildInputs = [
    cmake
    ensureNewerSourcesForZipFilesHook
    pkg-config
    python
    python.pkgs.pip
    swig4
    unzip
  ];
  buildInputs = [
    bzip2
    cbc
    eigen
    glpk
    python.pkgs.absl-py
    python.pkgs.mypy-protobuf
    python.pkgs.pybind11
    python.pkgs.setuptools
    python.pkgs.wheel
    re2
    zlib
  ];
  propagatedBuildInputs = [
    abseil-cpp
    protobuf
    python.pkgs.protobuf
    python.pkgs.numpy
  ];
  checkInputs = [
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

  outputs = [ "out" "python" ];

  meta = with lib; {
    homepage = "https://github.com/google/or-tools";
    license = licenses.asl20;
    description = ''
      Google's software suite for combinatorial optimization.
    '';
    maintainers = with maintainers; [ andersk ];
    platforms = with platforms; linux;
  };
}
