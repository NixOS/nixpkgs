{ stdenv
, fetchurl
# native
, cmake
, pkg-config
# not native
, asio
, openssl
, pcre2
, zlib
, catch2
, http-parser
}:

stdenv.mkDerivation rec {
  pname = "restinio";
  version = "0.6.8.1";

  # Ideally we would have used the git clone, but it's impossible to use it
  # without failing build. See https://github.com/Stiffstream/restinio/pull/6
  src = fetchurl {
    url = "https://github.com/Stiffstream/restinio/releases/download/v.${version}/${pname}-${version}-full.tar.bz2";
    sha256 = "0vy91njksyyhp00vx5q5xw4wi4xkbg10dky2a0zn3d2knvv63ixx";
  };
  patches = [
    ./remove-failing-tests.patch
  ];
  preConfigure = ''
    cd dev
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [
    asio
    openssl
    pcre2
    zlib
    catch2
    http-parser
  ];

  cmakeFlags = [
    "-DRESTINIO_USE_EXTERNAL_HTTP_PARSER=ON"
    # Build and run tests but don't build or install samples and benchmarks
    "-DRESTINIO_TEST=ON"
    "-DRESTINIO_SAMPLE=OFF"
    "-DRESTINIO_INSTALL_SAMPLES=OFF"
    "-DRESTINIO_BENCH=OFF"
    "-DRESTINIO_INSTALL_BENCHES=OFF"
  ];

  doCheck = true;

  meta = with stdenv.lib; {
    description = "Cross-platform, efficient, customizable, and robust asynchronous HTTP/WebSocket server C++14 library";
    homepage = "https://github.com/Stiffstream/restinio";
    license = licenses.free; # See https://github.com/Stiffstream/restinio/blob/master/LICENSE
    # see:
    # https://github.com/NixOS/nixpkgs/pull/94460/checks?check_run_id=937777778
    # and: https://github.com/Stiffstream/restinio/pull/6
    broken = stdenv.isDarwin;
    maintainers = [ maintainers.doronbehar ];
    platforms = platforms.all;
  };
}
