{ lib
, stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  pname = "intel-gmmlib";
  version = "21.2.2";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "gmmlib";
    rev = "${pname}-${version}";
    sha256 = "134l0d74ai4mqlp244nvkvg3mgzbzy20mjd274yay8g8hvb1g90v";
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
    maintainers = with maintainers; [ primeos ];
  };
}
