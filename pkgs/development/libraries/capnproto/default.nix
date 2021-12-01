{ lib, stdenv, fetchFromGitHub, capnproto, cmake }:

stdenv.mkDerivation rec {
  pname = "capnproto";
  version = "0.9.0";

  # release tarballs are missing some ekam rules
  src = fetchFromGitHub {
    owner = "capnproto";
    repo = "capnproto";
    rev = "v${version}";
    sha256 = "038i40apywn8sg95kwld4mg9p9m08izcw5xj7mwkmshycmqw65na";
  };

  nativeBuildInputs = [ cmake ]
    ++ lib.optional (!(stdenv.hostPlatform.isCompatible stdenv.buildPlatform)) capnproto;

  cmakeFlags = lib.optional (!(stdenv.hostPlatform.isCompatible stdenv.buildPlatform)) "-DEXTERNAL_CAPNP";

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
