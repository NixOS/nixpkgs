{ lib, stdenv, fetchFromGitHub, libjpeg, zlib, cmake, perl }:

stdenv.mkDerivation rec {
  pname = "qpdf";
  version = "11.6.1";

  src = fetchFromGitHub {
    owner = "qpdf";
    repo = "qpdf";
    rev = "v${version}";
    hash = "sha256-QXRzvSMi6gKISJo44KIjTYENNqxh1yDhUUhEZa8uz6Q=";
  };

  patches = [
    ./11.6.1-CVE-2024-24246.patch
  ];

  nativeBuildInputs = [ cmake perl ];

  buildInputs = [ zlib libjpeg ];

  preConfigure = ''
    patchShebangs qtest/bin/qtest-driver
    patchShebangs run-qtest
    # qtest needs to know where the source code is
    substituteInPlace CMakeLists.txt --replace "run-qtest" "run-qtest --top $src --code $src --bin $out"
  '';

  doCheck = true;

  meta = with lib; {
    homepage = "https://qpdf.sourceforge.io/";
    description = "A C++ library and set of programs that inspect and manipulate the structure of PDF files";
    license = licenses.asl20; # as of 7.0.0, people may stay at artistic2
    maintainers = with maintainers; [ abbradar ];
    platforms = platforms.all;
    changelog = "https://github.com/qpdf/qpdf/blob/v${version}/ChangeLog";
  };
}
