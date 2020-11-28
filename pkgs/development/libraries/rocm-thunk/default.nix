{ stdenv
, fetchFromGitHub
, cmake
, pkg-config
, numactl
}:

stdenv.mkDerivation rec {
  pname = "rocm-thunk";
  version = "3.9.0";

  src = fetchFromGitHub {
    owner = "RadeonOpenCompute";
    repo = "ROCT-Thunk-Interface";
    rev = "rocm-${version}";
    sha256 = "0xkp50ik7miz9whywnmiiqiamc7g8flfr9g8c02kxr0cay1in6cj";
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
