{ stdenv, fetchFromGitHub, cmake }:

let version = "0.4.0";
in stdenv.mkDerivation rec {
  name = "xtl-${version}";

  src = fetchFromGitHub {
    owner = "QuantStack";
    repo = "xtl";
    rev = version;
    sha256 = "1qd1ij78bp62702gpp4bfjvk8j01kxs5pv5ivqfhrj7xmqy88hxf";
  };

  nativeBuildInputs = [ cmake ];

  meta = with stdenv.lib; {
    description = "C++ QuantStack tools library";
    homepage = https://github.com/QuantStack/xtl;
    license = licenses.bsd3;
    maintainers =  with stdenv.lib.maintainers; [ mredaelli ];    
  };
}
