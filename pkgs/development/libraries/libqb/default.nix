{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkg-config, libxml2 }:

stdenv.mkDerivation rec {
  pname = "libqb";
  version = "2.0.8";

  src = fetchFromGitHub {
    owner = "ClusterLabs";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ZjxC7W4U8T68mZy/OvWj/e4W9pJIj2lVDoEjxXYr/G8=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];

  buildInputs = [ libxml2 ];

  postPatch = ''
    sed -i '/# --enable-new-dtags:/,/--enable-new-dtags is required/ d' configure.ac
  '';

  meta = with lib; {
    homepage = "https://github.com/clusterlabs/libqb";
    description = "A library providing high performance logging, tracing, ipc, and poll";
    license = licenses.lgpl21Plus;
    platforms = platforms.unix;
  };
}
