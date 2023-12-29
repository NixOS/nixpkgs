{ lib
, stdenv
, fetchFromGitHub
, cmake
, openssl
, zlib
}:

stdenv.mkDerivation rec {
  pname = "capnproto";
  version = "1.0.1.1";

  # release tarballs are missing some ekam rules
  src = fetchFromGitHub {
    owner = "capnproto";
    repo = "capnproto";
    rev = "v${version}";
    sha256 = "sha256-LFpCQiepPG78iMq/d3NAN6cSZI1X0QgkKRIxeeZhfEQ=";
  };

  nativeBuildInputs = [ cmake ];
  propagatedBuildInputs = [ openssl zlib ];

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
    maintainers = with maintainers; [ ];
  };
}
