{ stdenv, fetchFromGitHub, cmake, abseil-cpp, gflags, which
, lsb-release, glog, protobuf3_11, cbc, zlib
, ensureNewerSourcesForZipFilesHook, python, swig }:

let
  protobuf = protobuf3_11;
  pythonProtobuf = python.pkgs.protobuf.override { inherit protobuf; };

in stdenv.mkDerivation rec {
  pname = "or-tools";
  version = "7.5";

  src = fetchFromGitHub {
    owner = "google";
    repo = "or-tools";
    rev = "v${version}";
    sha256 = "1p9jwdwzcsaa58ap912hdf2w27vna3xl9g4lh6kjskddwi8l3wac";
  };

  # The original build system uses cmake which does things like pull
  # in dependencies through git and Makefile creation time. We
  # obviously don't want to do this so instead we provide the
  # dependencies straight from nixpkgs and use the make build method.
  configurePhase = ''
    cat <<EOF > Makefile.local
    UNIX_ABSL_DIR=${abseil-cpp}
    UNIX_GFLAGS_DIR=${gflags}
    UNIX_GLOG_DIR=${glog}
    UNIX_PROTOBUF_DIR=${protobuf}
    UNIX_CBC_DIR=${cbc}
    EOF
  '';

  makeFlags = [
    "prefix=${placeholder "out"}"
    "PROTOBUF_PYTHON_DESC=${pythonProtobuf}/${python.sitePackages}/google/protobuf/descriptor_pb2.py"
  ];
  buildFlags = [ "cc" "pypi_archive" ];

  checkTarget = "test_cc";
  doCheck = true;

  installTargets = [ "install_cc" ];
  # The upstream install_python target installs to $HOME.
  postInstall = ''
    mkdir -p "$python/${python.sitePackages}"
    (cd temp_python/ortools; PYTHONPATH="$python/${python.sitePackages}:$PYTHONPATH" python setup.py install '--prefix=$python')
  '';

  nativeBuildInputs = [
    cmake lsb-release swig which zlib python
    ensureNewerSourcesForZipFilesHook
    python.pkgs.setuptools python.pkgs.wheel
  ];
  propagatedBuildInputs = [
    abseil-cpp gflags glog protobuf cbc
    pythonProtobuf python.pkgs.six
  ];

  enableParallelBuilding = true;

  outputs = [ "out" "python" ];

  meta = with stdenv.lib; {
    homepage = https://github.com/google/or-tools;
    license = licenses.asl20;
    description = ''
      Google's software suite for combinatorial optimization.
    '';
    maintainers = with maintainers; [ andersk ];
    platforms = with platforms; linux;
  };
}
