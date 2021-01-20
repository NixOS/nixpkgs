{ bctoolbox
, belr
, cmake
, fetchFromGitLab
, stdenv
}:

stdenv.mkDerivation rec {
  pname = "belcard";
  version = "4.4.24";

  src = fetchFromGitLab {
    domain = "gitlab.linphone.org";
    owner = "public";
    group = "BC";
    repo = pname;
    rev = version;
    sha256 = "sha256-FTHtd93LOnRek9fqvI+KBkk/+53Bwy9GKCEo0NDtops=";
  };

  buildInputs = [ bctoolbox belr ];
  nativeBuildInputs = [ cmake ];

  # Do not build static libraries
  cmakeFlags = [ "-DENABLE_STATIC=NO" ];

  meta = with stdenv.lib; {
    description = "C++ library to manipulate VCard standard format";
    homepage = "https://gitlab.linphone.org/BC/public/belcard";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ jluttine ];
  };
}
