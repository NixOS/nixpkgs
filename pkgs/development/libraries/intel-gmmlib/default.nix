{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, cmake
# for passthru.tests
, intel-compute-runtime
, intel-media-driver
}:

stdenv.mkDerivation rec {
  pname = "intel-gmmlib";
  version = "22.3.7";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "gmmlib";
    rev = "intel-gmmlib-${version}";
    sha256 = "sha256-/iwTPWRVTZk1dhZD2Grcnc76ItgXjf2VrFD+93h8YvM=";
  };

  patches = [
    # fix build on i686
    # https://github.com/intel/gmmlib/pull/104
    (fetchpatch {
      url = "https://github.com/intel/gmmlib/commit/2526286f29d8ad3d3a5833bdc29e23e5f3300b34.patch";
      hash = "sha256-mChK6wprAt+bo39g6LTNy25kJeGoKabpXFq2gSDhaPw=";
    })
  ];

  nativeBuildInputs = [ cmake ];

  passthru.tests = {
    inherit intel-compute-runtime intel-media-driver;
  };

  meta = with lib; {
    homepage = "https://github.com/intel/gmmlib";
    license = licenses.mit;
    description = "Intel Graphics Memory Management Library";
    longDescription = ''
      The Intel(R) Graphics Memory Management Library provides device specific
      and buffer management for the Intel(R) Graphics Compute Runtime for
      OpenCL(TM) and the Intel(R) Media Driver for VAAPI.
    '';
    platforms = [ "x86_64-linux" "i686-linux" ];
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
