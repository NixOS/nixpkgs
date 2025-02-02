{ bctoolbox
, cmake
, fetchFromGitLab
, lib
, stdenv
}:

stdenv.mkDerivation rec {
  pname = "belr";
  version = "5.2.98";

  src = fetchFromGitLab {
    domain = "gitlab.linphone.org";
    owner = "public";
    group = "BC";
    repo = pname;
    rev = version;
    hash = "sha256-4keVUAsTs1DAhOfV71VD28I0PEHnyvW95blplY690LY=";
  };

  buildInputs = [ bctoolbox ];
  nativeBuildInputs = [ cmake ];

  # Do not build static libraries
  cmakeFlags = [ "-DENABLE_STATIC=NO" ];

  meta = with lib; {
    description = "Belledonne Communications' language recognition library. Part of the Linphone project.";
    homepage = "https://gitlab.linphone.org/BC/public/belr";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ jluttine ];
  };
}
