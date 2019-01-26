{ stdenv, fetchFromGitHub, cmake, google-gflags, which
, lsb-release, glog, protobuf, cbc, zlib, python3 }:

stdenv.mkDerivation rec {
  name = "or-tools-${version}";
  version = "v6.10";

  src = fetchFromGitHub {
    owner = "google";
    repo = "or-tools";
    rev = version;
    sha256 = "11k3671rpv968dsglc6bgarr9yi8ijaaqm2wq3m0rn4wy8fj7za2";
  };

  # The original build system uses cmake which does things like pull
  # in dependencies through git and Makefile creation time. We
  # obviously don't want to do this so instead we provide the
  # dependencies straight from nixpkgs and use the make build method.
  configurePhase = ''
    cat <<EOF > Makefile.local
    UNIX_GFLAGS_DIR=${google-gflags}
    UNIX_GLOG_DIR=${glog}
    UNIX_PROTOBUF_DIR=${protobuf}
    UNIX_CBC_DIR=${cbc}
    EOF
  '';

  makeFlags = [ "prefix=${placeholder "out"}" ];
  buildFlags = [ "cc" ];

  checkTarget = "test_cc";
  doCheck = true;

  installTargets = [ "install_cc" ];

  nativeBuildInputs = [
    cmake lsb-release which zlib python3
  ];
  propagatedBuildInputs = [
    google-gflags glog protobuf cbc
  ];

  enableParallelBuilding = true;

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
