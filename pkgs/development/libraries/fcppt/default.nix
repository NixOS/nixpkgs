{ lib, stdenv, fetchFromGitHub, cmake, boost, catch2 }:
stdenv.mkDerivation rec {
  pname = "fcppt";
  version = "4.2.1";

  src = fetchFromGitHub {
    owner = "freundlich";
    repo = "fcppt";
    rev = version;
    sha256 = "1pcmi2ck12nanw1rnwf8lmyx85iq20897k6daxx3hw5f23j1kxv6";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ boost catch2 ];

  cmakeFlags = [
    "-DENABLE_BOOST=true"
    "-DENABLE_EXAMPLES=true"
    "-DENABLE_CATCH=true"
    "-DENABLE_TEST=true"
  ];

  meta = with lib; {
    description = "Freundlich's C++ toolkit";
    longDescription = ''
      Freundlich's C++ Toolkit (fcppt) is a collection of libraries focusing on
      improving general C++ code by providing better types, a strong focus on
      C++11 (non-conforming compilers are mostly not supported) and functional
      programming (which is both efficient and syntactically affordable in
      C++11).
    '';
    homepage = "https://fcppt.org";
    license = licenses.boost;
    maintainers = with maintainers; [ pmiddend ];
    platforms = [ "x86_64-linux" "x86_64-windows" ];
  };
}
