{ lib
, pkgs
, stdenv
, fetchFromGitLab
, autoconf
, automake
, perl
, libtool
, vala
}:

stdenv.mkDerivation rec {
  pname = "lomiri-click";
  version = "unstable-2022-10-27";

  src = fetchFromGitLab {
    domain = "gitlab.com";
    owner = "ubports";
    repo = "development/core/click";
    rev = "e41fec1f635b70a746fb3c6c1ed2b5c3980c01c3";
    sha256 = "sha256-xKoFnwREYRE7pyeNk4xu5fXAvLBuYGxQhOIaOwoGA2I=";
  };

  nativeBuildInputs = [
    autoconf
    automake
  ];

  buildInputs = [
    perl
    libtool
    vala
  ];

  preConfigure = ''
    ./autogen.sh
  '';

  meta = with lib; {
    description = "Lomiri API library";
    homepage = "https://gitlab.com/ubports/development/core/lomiri-api";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ onny ];
  };

}
