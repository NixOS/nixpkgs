{ bctoolbox
, belle-sip
, cmake
, fetchFromGitLab
, soci
, sqlite
, stdenv
}:

stdenv.mkDerivation rec {
  pname = "lime";
  version = "4.3.1";

  src = fetchFromGitLab {
    domain = "gitlab.linphone.org";
    owner = "public";
    group = "BC";
    repo = pname;
    rev = version;
    sha256 = "1ilpp9ai4sah23ngnxisvmwhrv5jkk5f831yp7smpl225z5nv83g";
  };

  buildInputs = [ bctoolbox soci belle-sip sqlite ];
  nativeBuildInputs = [ cmake ];

  # Do not build static libraries
  cmakeFlags = [ "-DENABLE_STATIC=NO" ];

  meta = with stdenv.lib; {
    description = "End-to-end encryption library for instant messaging";
    homepage = "http://www.linphone.org/technical-corner/lime";
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ jluttine ];
  };
}
