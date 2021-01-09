{ stdenv
, fetchFromGitHub
, cmake
, pkg-config
, numactl
}:

stdenv.mkDerivation rec {
  pname = "rocm-thunk";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "RadeonOpenCompute";
    repo = "ROCT-Thunk-Interface";
    rev = "rocm-${version}";
    hash = "sha256-2kLSlGwX3pD8I5pXwV5L0k9l8OzJRkUvnAqv5E+gcd4=";
  };

  preConfigure = ''
    export cmakeFlags="$cmakeFlags "
  '';

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [ numactl ];

  postInstall = ''
    cp -r $src/include $out
  '';

  meta = with stdenv.lib; {
    description = "Radeon open compute thunk interface";
    homepage = "https://github.com/RadeonOpenCompute/ROCT-Thunk-Interface";
    license = with licenses; [ bsd2 mit ];
    maintainers = with maintainers; [ danieldk ];
  };
}
