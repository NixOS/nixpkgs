{ lib
, stdenv
, blas
, lapack
, openfst
, icu
, pkg-config
, fetchFromGitHub
, git
, python3
, openblas
, zlib
, gfortran
}:

let
  old-openfst = openfst.overrideAttrs (self: {
    src = fetchFromGitHub {
      owner = "kkm000";
      repo = "openfst";
      rev = "0bca6e76d24647427356dc242b0adbf3b5f1a8d9";
      sha256 = "1802rr14a03zl1wa5a0x1fa412kcvbgprgkadfj5s6s3agnn11rx";
    };
    buildInputs = [ zlib ];
  }); in

assert blas.implementation == "openblas" && lapack.implementation == "openblas";

stdenv.mkDerivation rec {
  pname = "kaldi";
  version = "kag-v2.1.0";

  src = fetchFromGitHub {
    owner = "daanzu";
    repo = "kaldi-fork-active-grammar";
    rev = version;
    sha256 = "+kT2xJRwDj/ECv/v/J1FpsINWOK8XkP9ZvZ9moFRl70=";
  };

  patches = [
    ./0004-fork-cmake.patch
    ./0006-fork-configure.patch
  ];

  enableParallelBuilding = true;

  buildInputs = [
    openblas
    old-openfst
    icu
  ];

  nativeBuildInputs = [
    pkg-config
    python3
    gfortran
  ];

  buildFlags = [
    "dragonfly"
    "dragonflybin"
    "bin"
    "fstbin"
    "lmbin"
  ];

  postPatch = ''
    # Replace the shebangs for the various build scripts
    patchShebangs src
  '';

  configurePhase = ''
    cd src
    ./configure --shared --fst-root="${old-openfst}" --use-cuda=no --openblas-root="${openblas}" --mathlib=OPENBLAS
  '';

  installPhase = ''
    # Fixes "patchelf: wrong ELF type"
    find . -type f -name "*.o" -print0 | xargs -0 rm -f
    mkdir -p $out/{bin,lib}
    cp lib/* $out/lib/
    patchelf \
      --set-rpath "${lib.makeLibraryPath buildInputs}:$out/lib" \
      $out/lib/*
  '';

  meta = with lib; {
    description = "Speech Recognition Toolkit";
    homepage = "https://kaldi-asr.org";
    license = licenses.mit;
    maintainers = with maintainers; [ ckie ];
    platforms = platforms.linux;
  };
}
