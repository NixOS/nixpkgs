{
  stdenv,
  fetchFromGitHub,
  lib,
  fzf,
  xclip,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "unipicker";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "jeremija";
    repo = "unipicker";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Br9nCK5eWoSN1i4LM2F31B62L9vuN5KzjS9pC9lq9oM=";
  };

  buildInputs = [
    fzf
    xclip
  ];

  preInstall = ''
    substituteInPlace unipicker \
      --replace-fail "/etc/unipickerrc" "$out/etc/unipickerrc" \
      --replace-fail "fzf" "${fzf}/bin/fzf"
    substituteInPlace unipickerrc \
      --replace-fail "/usr/local" "$out" \
      --replace-fail "fzf" "${fzf}/bin/fzf"
  '';

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "DESTDIR=${placeholder "out"}"
  ];

  meta = {
    description = "CLI utility for searching unicode characters by description and optionally copying them to clipboard";
    homepage = "https://github.com/jeremija/unipicker";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sigmanificient ];
    platforms = lib.platforms.unix;
    mainProgram = "unipicker";
  };
})
