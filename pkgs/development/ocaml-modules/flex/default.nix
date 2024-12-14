{
  buildDunePackage,
  fetchFromGitHub,
  lib,
  reason,
}:

buildDunePackage rec {
  pname = "flex";
  version = "unstable-2020-09-12";

  src = fetchFromGitHub {
    owner = "jordwalke";
    repo = "flex";
    rev = "6ff12fe4f96749ffd3c0ea3d9962742767937b4a";
    sha256 = "sha256-GomTOdlU5ZwElKK8CM4DEMr51YDIrFKmTxUCGMLL3c4=";
  };

  nativeBuildInputs = [ reason ];

  meta = with lib; {
    description = "Native Reason implementation of CSS Flexbox layout. An Yoga project port";
    homepage = "https://github.com/jordwalke/flex";
    maintainers = [ ];
    license = licenses.mit;
  };
}
