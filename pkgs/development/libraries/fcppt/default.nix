{ lib, stdenv, fetchFromGitHub, cmake, boost, catch2, metal }:
stdenv.mkDerivation rec {
  pname = "fcppt";
  version = "3.5.0";

  src = fetchFromGitHub {
    owner = "freundlich";
    repo = "fcppt";
    rev = version;
    sha256 = "045cmn4sym6ria96l4fsc1vrs8l4xrl1gzkmja82f4ddj8qkji2f";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ boost catch2 metal ];

  cmakeFlags = [ "-DCMAKE_SKIP_BUILD_RPATH=false" "-DENABLE_BOOST=true" "-DENABLE_EXAMPLES=true" "-DENABLE_CATCH=true" "-DENABLE_TEST=true" ];

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
    platforms = platforms.linux;
  };
}
