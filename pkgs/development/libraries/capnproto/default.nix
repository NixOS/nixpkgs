{ lib
, stdenv
, fetchFromGitHub
, capnproto
, cmake }:

stdenv.mkDerivation rec {
  pname = "capnproto";
  version = "0.9.1";

  # release tarballs are missing some ekam rules
  src = fetchFromGitHub {
    owner = "capnproto";
    repo = "capnproto";
    rev = "v${version}";
    sha256 = "0cbiwkmd29abih8rjjm35dfkrkr8c6axbzq3fkryay6jyvpi42c5";
  };

  nativeBuildInputs = [ cmake ]
    ++ lib.optional (!(stdenv.hostPlatform.isCompatible stdenv.buildPlatform)) capnproto;

  cmakeFlags = lib.optional (!(stdenv.hostPlatform.isCompatible stdenv.buildPlatform)) "-DEXTERNAL_CAPNP";

  # Upstream 77ac9154440bcc216fda1092fd5bb51da62ae09c, modified to apply to v0.9.1.  Drop on update.
  patches = lib.optional stdenv.hostPlatform.isMusl ./musl-no-fibers.patch;

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
