{ bctoolbox
, cmake
, fetchFromGitLab
, stdenv
}:

stdenv.mkDerivation rec {
  pname = "belr";
  # Using master branch for linphone-desktop caused a chain reaction that many
  # of its dependencies needed to use master branch too.
  version = "unstable-2020-03-09";

  src = fetchFromGitLab {
    domain = "gitlab.linphone.org";
    owner = "public";
    group = "BC";
    repo = pname;
    rev = "326d030ca9db12525c2a6d2a65f386f36f3c2ed5";
    sha256 = "1cdblb9smncq3al0crqp5651b02k1g6whlw1ib769p61gad0rs3v";
  };

  buildInputs = [ bctoolbox ];
  nativeBuildInputs = [ cmake ];

  # Do not build static libraries
  cmakeFlags = [ "-DENABLE_STATIC=NO" ];

  meta = with stdenv.lib; {
    description = "Belr is Belledonne Communications' language recognition library";
    homepage = "https://gitlab.linphone.org/BC/public/belr";
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ jluttine ];
  };
}
