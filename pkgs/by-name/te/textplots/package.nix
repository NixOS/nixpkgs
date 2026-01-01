{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "textplots";
  version = "0.8.5";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-83EAe6O8ETsuGJ5MK6kt68OnJL+r+BAYkFzvzlxHyp4=";
  };

  cargoHash = "sha256-ep7gXTWHRhWpGo6n/EgjY0d/vqIqd3yEikzy9sLTtf8=";

  buildFeatures = [ "tool" ];

<<<<<<< HEAD
  meta = {
    description = "Terminal plotting written in Rust";
    homepage = "https://github.com/loony-bean/textplots-rs";
    license = lib.licenses.mit;
=======
  meta = with lib; {
    description = "Terminal plotting written in Rust";
    homepage = "https://github.com/loony-bean/textplots-rs";
    license = licenses.mit;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
    mainProgram = "textplots";
  };
}
