{ lib
, stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  pname = "intel-gmmlib";
  version = "21.3.2";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "gmmlib";
    rev = "intel-gmmlib-${version}";
    sha256 = "0whi7dmdv36d5l90yhjyv2raj2j165q82h7df9a6wf2abvsaqvdh";
  };

  nativeBuildInputs = [ cmake ];

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
    maintainers = with maintainers; [ primeos SuperSandro2000 ];
  };
}
