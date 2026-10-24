{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  autoconf-archive,
  fontforge,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tlwg-arundina";
  version = "0.4.0";
  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "tlwg";
    repo = "fonts-arundina";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-ZiLMqgl+kpf9bT9591f20hH+fB2H5po37Mn4jfWAIhM=";
  };

  nativeBuildInputs = [
    autoreconfHook
    autoconf-archive
  ];

  buildInputs = [ fontforge ];

  meta = {
    description = "The Arundina font, provided by the Thai Linux Working Group.";
    homepage = "https://github.com/tlwg/fonts-arundina";
    license = with lib.licenses; [ bitstreamVera ];
    maintainers = [ lib.maintainers.itscrystalline ];
  };
})
