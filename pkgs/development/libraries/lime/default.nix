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
  version = "4.4.0";

  src = fetchFromGitLab {
    domain = "gitlab.linphone.org";
    owner = "public";
    group = "BC";
    repo = pname;
    rev = version;
    sha256 = "14jg1zisjbzflw3scfqdbwy48wq3cp93l867vigb8l40lkc6n26z";
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
