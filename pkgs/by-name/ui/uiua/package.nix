{
  lib,
  rustPlatform,
  fetchFromGitHub,
  audioSupport ? true,
  alsa-lib,
  pkg-config
}:
rustPlatform.buildRustPackage {
  pname = "uiua";
  version = "unstable-2023-09-28";

  src = fetchFromGitHub {
    owner = "uiua-lang";
    repo = "uiua";
    rev = "9b8c65332396f521f170b0ed3ce104b7a8bcf7c0";
    hash = "sha256-+pleCEEwgRj+p+k9oKIvbsGUWC49qByV/juv76ZdBcc=";
  };

  cargoHash = "sha256-L8TCMe6eHS3QRy6HuTc1WvMfzsDhKx9YYupAkNeBwpk=";

  nativeBuildInputs = lib.optional audioSupport pkg-config;
  buildInputs = lib.optionals audioSupport [ alsa-lib ];
  buildFeatures = lib.optional audioSupport "audio";

  doCheck = true;

  meta = with lib; {
    description = "A stack-oriented array programming language with a focus on simplicity, beauty, and tacit code";
    longDescription = ''
      Uiua combines the stack-oriented and array-oriented paradigms in a single
      language. Combining these already terse paradigms results in code with a very
      high information density and little syntactic noise.
    '';
    homepage = "https://www.uiua.org/";
    license = licenses.mit;
    mainProgram = "uiua";
    maintainers = with maintainers; [cafkafk];
    # TODO: add MacOS support, it should be possible, but I don't own a Mac to
    # hack on
    platforms = platforms.linux;
  };
}
