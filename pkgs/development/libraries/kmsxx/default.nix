{ lib, stdenv, fetchFromGitHub, cmake, pkg-config, libdrm
, withPython ? false, python ? null }:

stdenv.mkDerivation {
  pname = "kmsxx";
  version = "2020-08-04";

  src = fetchFromGitHub {
    owner = "tomba";
    repo = "kmsxx";
    fetchSubmodules = true;
    rev = "38bee3092f2d477f1baebfcae464f888d3d04bbe";
    sha256 = "0xz4m9bk0naawxwpx5cy1j3cm6c8c9m5y551csk88y88x1g0z0xh";
  };

  cmakeFlags = lib.optional (!withPython) "-DKMSXX_ENABLE_PYTHON=OFF";

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ libdrm ] ++ lib.optionals withPython [ python ];

  meta = with lib; {
    description = "C++11 library, utilities and python bindings for Linux kernel mode setting";
    homepage = "https://github.com/tomba/kmsxx";
    license = licenses.mpl20;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
    broken = true; # marked broken 2021-03-26
  };
}
