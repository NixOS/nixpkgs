{ stdenv
, fetchFromGitHub
, cmake
, pkg-config
, numactl
}:

stdenv.mkDerivation rec {
  pname = "rocm-thunk";
  version = "3.5.0";

  src = fetchFromGitHub {
    owner = "RadeonOpenCompute";
    repo = "ROCT-Thunk-Interface";
    rev = "rocm-${version}";
    sha256 = "0xn1z0xc3phjc9vabwxgph5any4ffhc8wgs5yb15m5wpg87l8x1z";
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
