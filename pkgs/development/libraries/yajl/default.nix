{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "yajl";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "lloyd";
    repo = "yajl";
    rev = "refs/tags/${version}";
    sha256 = "00yj06drb6izcxfxfqlhimlrb089kka0w0x8k27pyzyiq7qzcvml";
  };

  nativeBuildInputs = [ cmake ];

  meta = {
    description = "Yet Another JSON Library";
    longDescription = ''
      YAJL is a small event-driven (SAX-style) JSON parser written in ANSI
      C, and a small validating JSON generator.
    '';
    homepage = "http://lloyd.github.com/yajl/";
    license = lib.licenses.isc;
    platforms = with lib.platforms; linux ++ darwin;
    maintainers = with lib.maintainers; [ maggesi ];
  };
}
