{ stdenv, fetchFromGitHub, cmake, google-gflags, which
, lsb-release, glog, protobuf, cbc, zlib }:

stdenv.mkDerivation rec {
  name = "or-tools-${version}";
  version = "v6.9.1";

  src = fetchFromGitHub {
    owner = "google";
    repo = "or-tools";
    rev = version;
    sha256 = "099j1mc7vvry0a2fiz9zvk6divivglzphv48wbw0c6nd5w8hb27c";
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

  buildPhase = ''
    make cc
  '';

  installPhase = ''
    make install_cc prefix=$out
  '';

  patches = [
    # In "expected" way of compilation, the glog package is compiled
    # with gflags support which then makes gflags header transitively
    # included through glog. However in nixpkgs we don't compile glog
    # with gflags so we have to include it ourselves. Upstream should
    # always include gflags to support both ways I think.
    #
    # Upstream ticket: https://github.com/google/or-tools/issues/902
    ./gflags-include.patch
  ];

  nativeBuildInputs = [
    cmake lsb-release which zlib
  ];
  propagatedBuildInputs = [
    google-gflags glog protobuf cbc
  ];

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
