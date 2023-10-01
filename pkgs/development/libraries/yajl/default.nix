{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation {
  pname = "yajl";
  version = "unstable-2022-04-20";

  src = fetchFromGitHub {
    owner = "containers";
    repo = "yajl";
    rev = "49923ccb2143e36850bcdeb781e2bcdf5ce22f15";
    hash = "sha256-9bMPA5FpyBp8fvG/kkT/MnhYtdqg3QzOnmDFXKwJVW0=";
  };

  patches = [
    # https://github.com/containers/yajl/pull/1
    ./cmake-shared-static-fix.patch
  ];

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
