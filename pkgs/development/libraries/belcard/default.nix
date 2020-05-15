{ bctoolbox
, belr
, cmake
, fetchFromGitLab
, stdenv
}:

stdenv.mkDerivation rec {
  pname = "belcard";
  version = "4.3.1";

  src = fetchFromGitLab {
    domain = "gitlab.linphone.org";
    owner = "public";
    group = "BC";
    repo = pname;
    rev = version;
    sha256 = "1w6rbp53cwxr00clp957458x27cgc2y9ylwa5mp812qva7zadmfw";
  };

  buildInputs = [ bctoolbox belr ];
  nativeBuildInputs = [ cmake ];

  # Do not build static libraries
  cmakeFlags = [ "-DENABLE_STATIC=NO" ];

  meta = with stdenv.lib; {
    description = "C++ library to manipulate VCard standard format";
    homepage = "https://gitlab.linphone.org/BC/public/belcard";
    license = licenses.lgpl21;
    platforms = platforms.all;
    maintainers = with maintainers; [ jluttine ];
  };
}
