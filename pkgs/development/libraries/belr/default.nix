{ bctoolbox
, cmake
, fetchFromGitLab
, lib, stdenv
}:

stdenv.mkDerivation rec {
  pname = "belr";
  version = "5.0.55";

  src = fetchFromGitLab {
    domain = "gitlab.linphone.org";
    owner = "public";
    group = "BC";
    repo = pname;
    rev = version;
    sha256 = "sha256-P3oDlaT3rN1lRhpKjbGBk7a0hJAQGQcWydFM45GMUU4=";
  };

  buildInputs = [ bctoolbox ];
  nativeBuildInputs = [ cmake ];

  # Do not build static libraries
  cmakeFlags = [ "-DENABLE_STATIC=NO" ];

  meta = with lib; {
    description = "Belledonne Communications' language recognition library";
    homepage = "https://gitlab.linphone.org/BC/public/belr";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ jluttine ];
  };
}
