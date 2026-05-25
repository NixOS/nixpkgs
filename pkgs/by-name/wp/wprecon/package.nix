{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "wprecon";
  version = "2.4.5";

  src = fetchFromGitHub {
    owner = "ffx64";
    repo = "wprecon";
    rev = version;
    hash = "sha256-23zJD3Nnkeko+J2FjPq5RA5dIjORMXvwt3wtAYiVlQs=";
  };

  vendorHash = "sha256-FYdsLcW6FYxSgixZ5US9cBPABOAVwidC3ejUNbs1lbA=";

  postFixup = ''
    # Rename binary
    mv $out/bin/cli $out/bin/wprecon
  '';

  meta = {
    description = "WordPress vulnerability recognition tool";
    homepage = "https://github.com/ffx64/wprecon";
    # License Zero Noncommercial Public License 2.0.1
    # https://github.com/ffx64/wprecon/blob/master/LICENSE
    license = with lib.licenses; [ unfree ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
