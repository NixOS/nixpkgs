{ lib, stdenv, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  pname = "intel-gmmlib";
  version = "20.4.1";

  src = fetchFromGitHub {
    owner  = "intel";
    repo   = "gmmlib";
    rev    = "${pname}-${version}";
    sha256 = "0qb0wpinfv8lg1pq1pxkl6v0kd8ax86m8zxzm6zjx91alsch1mi6";
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
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ primeos ];
  };
}
