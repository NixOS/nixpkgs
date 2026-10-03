{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "termbox";
  version = "1.1.4";
  src = fetchFromGitHub {
    owner = "termbox";
    repo = "termbox";
    rev = "v${finalAttrs.version}";
    hash = "sha256-dPp9dXK29vkQ6fvKRwDApVmjnXHr1dWIIBV1qczmuhw=";
  };

  makeFlags = [ "prefix=${placeholder "out"}" ];

  meta = {
    description = "Library for writing text-based user interfaces";
    license = lib.licenses.mit;
    homepage = "https://github.com/termbox/termbox#readme";
    downloadPage = "https://github.com/termbox/termbox/releases";
    maintainers = with lib.maintainers; [ fgaz ];
  };
})
