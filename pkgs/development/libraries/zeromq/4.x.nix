{ stdenv, fetchFromGitHub, cmake, asciidoc }:

stdenv.mkDerivation rec {
  name = "zeromq-${version}";
  version = "4.2.3";

  src = fetchFromGitHub {
    owner = "zeromq";
    repo = "libzmq";
    rev = "v${version}";
    sha256 = "1yadf4vz4m49lpwwwscxs6wf4v9dgqgxkwgwpby9lvb4pv8qbmaf";
  };

  nativeBuildInputs = [ cmake asciidoc ];

  enableParallelBuilding = true;

  postPatch = ''
    sed -i 's,''${PACKAGE_PREFIX_DIR}/,,g' ZeroMQConfig.cmake.in
  '';

  meta = with stdenv.lib; {
    branch = "4";
    homepage = http://www.zeromq.org;
    description = "The Intelligent Transport Layer";
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ wkennington fpletz ];
  };
}
