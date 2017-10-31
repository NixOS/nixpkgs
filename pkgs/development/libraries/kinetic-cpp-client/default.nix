{ stdenv, fetchgit, fetchurl, cmake, protobuf, libunwind, openssl, glog
, google-gflags, gmock, gtest
}:

let
  protoTar = fetchurl {
    url = "http://github.com/Seagate/kinetic-protocol/archive/3.0.0.tar.gz";
    sha256 = "0406pp0sdf0rg6s5g18r2d8si2rin7p6qbzp7c6pma5hyzsygz48";
  };
in
stdenv.mkDerivation rec {
  name = "kinetic-cpp-client-2015-04-14";

  src = fetchgit {
    url = "git://github.com/Seagate/kinetic-cpp-client.git";
    rev = "015085a5c89db0398f80923053f36b9e0611e107";
    sha256 = "0gm34sl6lyidnxgg1lrhkxkxqj8z1y2cqn7zhzz2f1k50pigi5da";
  };

  patches = [ ./build-fix.patch ];

  postPatch = ''
    mkdir -p build/kinetic-proto
    tar -x --strip-components 1 -C build/kinetic-proto -f ${protoTar}
  '';

  nativeBuildInputs = [ cmake protobuf ];
  buildInputs = [ libunwind glog google-gflags gmock gtest ];

  # The headers and library include from these and there is no provided pc file
  propagatedBuildInputs = [ protobuf openssl ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=true"
  ];

  preCheck = ''
    # The checks cannot find libkinetic_client.so otherwise
    export LD_LIBRARY_PATH="$(pwd)"
  '';

  installPhase = ''
    # There is no included install script so do our best
    mkdir -p $out/lib
    cp libkinetic_client.so $out/lib
    cp -r ../include $out
    cp ../src/main/generated/kinetic_client.pb.h $out/include
  '';

  doCheck = true;

  meta = with stdenv.lib; {
    homepage = https://github.com/Seagate/kinetic-cpp-client;
    description = "Code for producing C and C++ kinetic clients";
    license = licenses.lgpl21;
    platforms = platforms.unix;
    maintainers = with maintainers; [ wkennington ];
  };
}
