{ lib, stdenv, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  pname = "intel-gmmlib";
  version = "20.3.3";

  src = fetchFromGitHub {
    owner  = "intel";
    repo   = "gmmlib";
    rev    = "${pname}-${version}";
    sha256 = "1diq1gqpfv5bawvag6bzwnd3ilhacwmwx3bl67abjvbb0m3jw4lk";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    homepage = "https://github.com/intel/gmmlib";
    license = licenses.mit;
    description = "Intel Graphics Memory Management Library";
    platforms = [ "x86_64-linux" ];
  };
}
