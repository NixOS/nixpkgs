{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkg-config, libxml2 }:

stdenv.mkDerivation rec {
  pname = "libqb";
  version = "2.0.3";

  src = fetchFromGitHub {
    owner = "ClusterLabs";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-a9CnqfrQUL0DdPPOJjfh9tQ0O8iRHPP3iBmy3MKvt/0=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];

  buildInputs = [ libxml2 ];

  meta = with lib; {
    homepage = "https://github.com/clusterlabs/libqb";
    description = "A library providing high performance logging, tracing, ipc, and poll";
    license = licenses.lgpl21Plus;
    platforms = platforms.unix;
  };
}
