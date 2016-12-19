{ stdenv, lib, fetchFromGitHub, cmake }:

let
  version = "1.8.1";
in

stdenv.mkDerivation rec {
  name = "libobjc2-${version}";

  src = fetchFromGitHub {
    owner = "gnustep";
    repo = "libobjc2";
    rev = "v${version}";
    sha256 = "12v9pjg97h56mb114cqd22q1pdwhmxrgdw5hal74ddlrhiq1nzvi";
  };

  buildInputs = [ cmake ];

  cmakeFlags = [ "-DCMAKE_INSTALL_LIBDIR=lib" ];

  meta = with lib; {
    description = "Objective-C runtime for use with GNUstep";
    homepage = http://gnustep.org/;
    license = licenses.mit;
    maintainers = with maintainers; [ ashalkhakov matthewbauer ];
    platforms = platforms.unix;
  };
}
