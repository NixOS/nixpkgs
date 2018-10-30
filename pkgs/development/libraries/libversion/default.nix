{ stdenv, fetchFromGitHub, cmake }:

let
  version = "2.7.0";
in
stdenv.mkDerivation {
  name = "libversion-${version}";

  src = fetchFromGitHub {
    owner = "repology";
    repo = "libversion";
    rev = version;
    sha256 = "0brk2mbazc7yz0h4zsvbybbaymf497dgxnc74qihnvbi4z4rlqpj";
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
