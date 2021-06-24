{ bctoolbox
, belr
, cmake
, fetchFromGitLab
, lib, stdenv
}:

stdenv.mkDerivation rec {
  pname = "belcard";
  version = "4.5.1";

  src = fetchFromGitLab {
    domain = "gitlab.linphone.org";
    owner = "public";
    group = "BC";
    repo = pname;
    rev = version;
    sha256 = "14hkgwr2a9zw44v1s8xscqxa2mwin06jsxpwb3hflh9mp16ymfzv";
  };

  buildInputs = [ bctoolbox belr ];
  nativeBuildInputs = [ cmake ];

  # Do not build static libraries
  cmakeFlags = [ "-DENABLE_STATIC=NO" ];

  meta = with lib; {
    description = "C++ library to manipulate VCard standard format";
    homepage = "https://gitlab.linphone.org/BC/public/belcard";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ jluttine ];
  };
}
