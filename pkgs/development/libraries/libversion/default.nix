{ stdenv, fetchFromGitHub, cmake }:

let
  version = "2.8.1";
in
stdenv.mkDerivation {
  name = "libversion-${version}";

  src = fetchFromGitHub {
    owner = "repology";
    repo = "libversion";
    rev = version;
    sha256 = "0h0yfcgxll09dckzjb1im3yf54cjkpsflr7r4kwz1jcr3fxq41fz";
  };

  nativeBuildInputs = [ cmake ];

  doCheck = true;
  checkTarget = "test";

  meta = with stdenv.lib; {
    description = "Advanced version string comparison library";
    homepage = https://github.com/repology/libversion;
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ ryantm ];
    platforms = platforms.unix;
  };
}
