{ bctoolbox
, belle-sip
, cmake
, fetchFromGitLab
, lib
, bc-soci
, sqlite
, boost
, stdenv
}:

stdenv.mkDerivation rec {
  pname = "lime";
  version = "5.1.12";

  src = fetchFromGitLab {
    domain = "gitlab.linphone.org";
    owner = "public";
    group = "BC";
    repo = pname;
    rev = version;
    sha256 = "sha256-vgaxb8sfgtAhqG8kg3C4+UrTOHyTVR9QVO9iuKFgSBk=";
  };

  buildInputs = [
    # Made by BC
    bctoolbox
    belle-sip

    # Vendored by BC
    bc-soci

    sqlite
    boost
  ];
  nativeBuildInputs = [ cmake ];

  # Do not build static libraries
  cmakeFlags = [ "-DENABLE_STATIC=NO" ];

  meta = with lib; {
    description = "End-to-end encryption library for instant messaging. Part of the Linphone project.";
    homepage = "http://www.linphone.org/technical-corner/lime";
    license = licenses.gpl3Only;
    platforms = platforms.all;
    maintainers = with maintainers; [ jluttine ];
  };
}
