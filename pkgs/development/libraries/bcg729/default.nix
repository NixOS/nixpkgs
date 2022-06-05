{ lib, stdenv
, fetchFromGitLab
, cmake
}:

stdenv.mkDerivation rec {
  pname = "bcg729";
  version = "1.1.1";

  src = fetchFromGitLab {
    domain = "gitlab.linphone.org";
    owner = "public";
    group = "BC";
    repo = pname;
    rev = version;
    sha256 = "1hal6b3w6f8y5r1wa0xzj8sj2jjndypaxyw62q50p63garp2h739";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "Opensource implementation of both encoder and decoder of the ITU G729 Annex A/B speech codec";
    homepage = "https://linphone.org/technical-corner/bcg729";
    changelog = "https://gitlab.linphone.org/BC/public/bcg729/raw/${version}/NEWS";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ c0bw3b ];
    platforms = platforms.all;
  };
}
