{ stdenv, fetchFromGitHub, cmake, buildTests ? false, gmock ? null }:

assert buildTests -> gmock != null; 

let version = "4.0.0"
; in
stdenv.mkDerivation {
  name = "xsimd-${version}";

  src = fetchFromGitHub {
    owner = "QuantStack";
    repo = "xsimd";
    rev = version;
    sha256 = "08fv1ri62rq75k86mwcpxcg4dwz7gxbk189n1c8gav1yiy3m47rm";
  };

  nativeBuildInputs = [ cmake (if buildTests then gmock else null) ];
  cmakeFlags = if !buildTests then [ "-DBUILD_TESTS=OFF" ] else null;
  
  meta = with stdenv.lib; {
    description = "C++ wrappers for SIMD intrinsics";
    homepage = https://github.com/QuantStack/xsimd;
    license = licenses.bsd3;
    maintainers =  with stdenv.lib.maintainers; [ mredaelli ];
  };
}
