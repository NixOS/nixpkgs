{ lib
, stdenv
, fetchFromGitHub
, cmake
, abseil-cpp
, bzip2
, zlib
, lsb-release
, which
, protobuf
, cbc
, ensureNewerSourcesForZipFilesHook
, python
, swig4
}:

stdenv.mkDerivation rec {
  pname = "or-tools";
  version = "9.1";
  disabled = python.pythonOlder "3.6";  # not supported upstream

  src = fetchFromGitHub {
    owner = "google";
    repo = "or-tools";
    rev = "v${version}";
    sha256 = "sha256-dEYMPWpa3J9EqtCq3kubdUYJivNRTOKUpNDx3UC1IcQ=";
  };

  # The original build system uses cmake which does things like pull
  # in dependencies through git and Makefile creation time. We
  # obviously don't want to do this so instead we provide the
  # dependencies straight from nixpkgs and use the make build method.

  # Cbc is linked against bzip2 and declares this in its pkgs-config file,
  # but this makefile doesn't use pkgs-config, so we also have to add lbz2
  configurePhase = ''
    substituteInPlace makefiles/Makefile.third_party.unix.mk \
      --replace 'COINUTILS_LNK = $(STATIC_COINUTILS_LNK)' \
                'COINUTILS_LNK = $(STATIC_COINUTILS_LNK) -lbz2'

    cat <<EOF > Makefile.local
      UNIX_ABSL_DIR=${abseil-cpp}
      UNIX_PROTOBUF_DIR=${protobuf}
      UNIX_CBC_DIR=${cbc}
      USE_SCIP=OFF
    EOF
  '';

  # Many of these 'samples' (which are really the tests) require using SCIP, and or-tools 8.1
  # will just crash if SCIP is not found because it doesn't fall back to using one of
  # the available solvers: https://github.com/google/or-tools/blob/b77bd3ac69b7f3bb02f55b7bab6cbb4bab3917f2/ortools/linear_solver/linear_solver.cc#L427
  # We don't compile with SCIP because it does not have an open source license.
  # See https://github.com/google/or-tools/issues/2395
  preBuild = ''
    for file in ortools/linear_solver/samples/*.cc; do
      if grep -q SCIP_MIXED_INTEGER_PROGRAMMING $file; then
        substituteInPlace $file --replace SCIP_MIXED_INTEGER_PROGRAMMING CBC_MIXED_INTEGER_PROGRAMMING
      fi;
    done

    substituteInPlace ortools/linear_solver/samples/simple_mip_program.cc \
      --replace 'SCIP' 'CBC'
  '';
  makeFlags = [
    "prefix=${placeholder "out"}"
    "PROTOBUF_PYTHON_DESC=${python.pkgs.protobuf}/${python.sitePackages}/google/protobuf/descriptor_pb2.py"
  ];
  buildFlags = [ "cc" "pypi_archive" ];

  doCheck = true;
  checkTarget = "test_cc";

  installTargets = [ "install_cc" ];
  # The upstream install_python target installs to $HOME.
  postInstall = ''
    mkdir -p "$python/${python.sitePackages}"
    (cd temp_python/ortools; PYTHONPATH="$python/${python.sitePackages}:$PYTHONPATH" python setup.py install '--prefix=$python')
  '';

  # protobuf generation is not thread safe
  enableParallelBuilding = false;

  nativeBuildInputs = [
    cmake
    lsb-release
    swig4
    which
    ensureNewerSourcesForZipFilesHook
    python.pkgs.setuptools
    python.pkgs.wheel
  ];
  buildInputs = [
    zlib
    bzip2
    python
  ];
  propagatedBuildInputs = [
    abseil-cpp
    protobuf

    python.pkgs.protobuf
    python.pkgs.six
    python.pkgs.absl-py
    python.pkgs.mypy-protobuf
  ];

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
