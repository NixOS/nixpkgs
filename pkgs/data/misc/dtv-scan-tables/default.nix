{ lib
, stdenv
, fetchFromGitHub
, v4l-utils
}:

stdenv.mkDerivation rec {
  pname = "dtv-scan-tables";
  version = "20221027";

  src = fetchFromGitHub {
    owner = "tvheadend";
    repo = "dtv-scan-tables";
    rev = "2a3dbfbab129c00d3f131c9c2f06b2be4c06fec6";
    hash = "sha256-bJ+naUs3TDFul4PmpnWYld3j1Se+1X6U9jnECe3sno0=";
  };

  nativeBuildInputs = [
    v4l-utils
  ];

  makeFlags = [
    "PREFIX=$(out)"
  ];

  allowedReferences = [ ];

  meta = with lib; {
    description = "Digital TV scan tables";
    homepage = "https://github.com/tvheadend/dtv-scan-tables";
    license = with licenses; [ gpl2Only lgpl21Only ];
    maintainers = with maintainers; [ ];
  };
}
