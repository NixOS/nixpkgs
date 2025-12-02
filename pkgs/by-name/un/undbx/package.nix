{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "undbx";
  version = "0.22-unstable-2019-02-11";

  src = fetchFromGitHub {
    owner = "ZungBang";
    repo = "undbx";
    rev = "5e31c757e137a6409115cac0623d61d384019b7a";
    hash = "sha256-leregcv3dv/D3WvFkYyjQePdKi4BgE0aj5PY6JiSKl8=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  postPatch = ''
    substituteInPlace Makefile.am \
      --replace-fail "-Werror" "" \
      --replace-fail "bin_SCRIPTS" "#bin_SCRIPTS"
  '';
  meta = with lib; {
    description = "Extract e-mail messages from Outlook Express DBX files";
    homepage = "https://github.com/ZungBang/undbx";
    maintainers = with maintainers; [ d3vil0p3r ];
    platforms = platforms.unix;
    license = licenses.gpl3Plus;
    mainProgram = "undbx";
  };
})
