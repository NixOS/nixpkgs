{ lib, stdenv, fetchFromGitHub, rustPlatform, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "uwuify";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "Daniel-Liu-c0deb0t";
    repo = "uwu";
    rev = "v${version}";
    sha256 = "sha256-MzXObbxccwEG7egmQMCdhUukGqZS+NgbYwZjTaqME7I=";
  };

  cargoHash = "sha256-1BoB7K/dWy3AbogvHIDLrdPD7K54EISvn4RVU5RLTi4=";
  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ libiconv ];

  meta = with lib; {
    description = "Fast text uwuifier";
    homepage = "https://github.com/Daniel-Liu-c0deb0t/uwu";
    license = licenses.mit;
    platforms = lib.platforms.x86; # uses SSE instructions
    maintainers = with maintainers; [ siraben ];
    mainProgram = "uwuify";
  };
}
