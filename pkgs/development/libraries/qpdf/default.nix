{ lib, stdenv, fetchFromGitHub, libjpeg, zlib, cmake, perl }:

stdenv.mkDerivation rec {
  pname = "qpdf";
<<<<<<< HEAD
  version = "11.5.0";
=======
  version = "11.3.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "qpdf";
    repo = "qpdf";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-lojvsCgBsT7wVRLWfkeOduEYUG7ztI/uryM0WueWiL0=";
=======
    hash = "sha256-UZq973X93E+Ll1IKjfJNPQuQwBFOU3egFGODgXV21x0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

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
