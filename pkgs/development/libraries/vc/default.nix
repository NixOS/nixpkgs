{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  version = "1.1.0";
  name = "Vc-${version}";

  src = fetchFromGitHub {
    owner = "VcDevel";
    repo = "Vc";
    rev = version;
    sha256 = "1i27zpwcpsfabvf1vpyx5rlzkkgqfd55c3c0jq5fghywyj6743j8";
  };

  nativeBuildInputs = [ cmake ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Library for multiprecision complex arithmetic with exact rounding";
    homepage = https://github.com/VcDevel/Vc;
    license = licenses.bsd3;
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
    maintainers = with maintainers; [ abbradar ];
  };
}
