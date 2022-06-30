{ lib
, stdenv
, fetchFromGitHub
, capnproto
, cmake }:

stdenv.mkDerivation rec {
  pname = "capnproto";
  version = "0.10.1";

  # release tarballs are missing some ekam rules
  src = fetchFromGitHub {
    owner = "capnproto";
    repo = "capnproto";
    rev = "v${version}";
    sha256 = "sha256-VdeoTU802kAqTdu8CJTIhy3xHM3ZCPqb5YNUS2k1x7E=";
  };

  nativeBuildInputs = [ cmake ]
    ++ lib.optional (!(stdenv.buildPlatform.canExecute stdenv.hostPlatform)) capnproto;

  cmakeFlags = lib.optional (!(stdenv.buildPlatform.canExecute stdenv.hostPlatform)) "-DEXTERNAL_CAPNP";

  meta = with lib; {
    homepage    = "https://capnproto.org/";
    description = "Cap'n Proto cerealization protocol";
    longDescription = ''
      Cap’n Proto is an insanely fast data interchange format and
      capability-based RPC system. Think JSON, except binary. Or think Protocol
      Buffers, except faster.
    '';
    license     = licenses.mit;
    platforms   = platforms.all;
    maintainers = with maintainers; [ cstrahan ];
  };
}
