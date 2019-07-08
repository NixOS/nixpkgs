{ stdenv, fetchFromGitHub, cmake, abseil-cpp, google-gflags, which
, lsb-release, glog, protobuf, cbc, zlib
, ensureNewerSourcesForZipFilesHook, python, swig
, pythonProtobuf }:

stdenv.mkDerivation rec {
  name = "or-tools-${version}";
  version = "v7.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "or-tools";
    rev = version;
    sha256 = "09rs2j3w4ljw9qhhnsjlvfii297njjszwvkbgj1i6kns3wnlr7cp";
  };

  # The original build system uses cmake which does things like pull
  # in dependencies through git and Makefile creation time. We
  # obviously don't want to do this so instead we provide the
  # dependencies straight from nixpkgs and use the make build method.
  configurePhase = ''
    cat <<EOF > Makefile.local
    UNIX_ABSL_DIR=${abseil-cpp}
    UNIX_GFLAGS_DIR=${google-gflags}
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
    abseil-cpp google-gflags glog protobuf cbc
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
    maintainers = with maintainers; [ fuuzetsu ];
    platforms = with platforms; linux;
  };
}
