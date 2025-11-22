{
  stdenv,
  lib,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "umka";
  version = "1.5.4";

  src = fetchFromGitHub {
    owner = "vtereshkov";
    repo = "umka-lang";
    tag = "v${finalAttrs.version}";
    hash = "sha256-UerEmJdD0/Hx/Pqw3NI3cZwjkX9lRWqI5rL0GGYKFwc=";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail "RANLIB                = libtool -static -o" "RANLIB = ar -cru"
  ''
  + lib.optionalString (!stdenv.hostPlatform.isx86) ''
    substituteInPlace Makefile \
      --replace-fail "-malign-double" ""
  '';

  makeFlags = [
    "PREFIX=$(out)"
  ];

  meta = {
    description = "Statically typed embeddable scripting language";
    homepage = "https://github.com/vtereshkov/umka-lang";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ f64u ];
    mainProgram = "umka";
  };
})
