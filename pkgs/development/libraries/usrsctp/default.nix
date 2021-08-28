{ stdenv, lib, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "usrsctp";
  version = "0.9.5.0";

  src = fetchFromGitHub {
    owner = "sctplab";
    repo = "usrsctp";
    rev = version;
    sha256 = "10ndzkip8blgkw572n3dicl6mgjaa7kygwn3vls80liq92vf1sa9";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    homepage = "https://github.com/sctplab/usrsctp";
    description = "A portable SCTP userland stack";
    maintainers = with maintainers; [ misuzu ];
    license = licenses.bsd3;
    platforms = platforms.unix;
  };
}
