{ stdenv, lib, fetchFromGitHub, pkgconfig, protobuf, automake
, autoreconfHook, zlib
, enableGrpc ? false
}:

let
  # be sure to use the right revision based on the submodule!
  common =
    fetchFromGitHub {
      owner = "lightstep";
      repo = "lightstep-tracer-common";
      rev = "fe1f65f4a221746f9fffe8bf544c81d4e1b8aded";
      sha256 = "1qqpjxfrjmhnhs15nhbfv28fsgzi57vmfabxlzc99j4vl78h5iln";
    };

in

stdenv.mkDerivation rec {
  name = "lightstep-tracer-cpp-${version}";
  version = "0.36";

  src = fetchFromGitHub {
    owner = "lightstep";
    repo = "lightstep-tracer-cpp";
    rev = "v0_36";
    sha256 = "1sfj91bn7gw7fga7xawag076c8j9l7kiwhm4x3zh17qhycmaqq16";
  };

  postUnpack = ''
    cp -r ${common}/* $sourceRoot/lightstep-tracer-common
  '';

  preConfigure = lib.optionalString (!enableGrpc) ''
    configureFlagsArray+=("--disable-grpc")
  '';

  nativeBuildInputs = [
    pkgconfig automake autoreconfHook
  ];

  buildInputs = [
    protobuf zlib
  ];

  meta = with lib; {
    description = "Distributed tracing system built on top of the OpenTracing standard";
    homepage = "https://lightstep.com/";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ cstrahan ];
    broken = true; # 2018-02-16
  };
}
