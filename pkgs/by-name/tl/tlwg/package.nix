{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  autoconf-archive,
  fontforge,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tlwg";
  version = "0.7.4";

  src = fetchFromGitHub {
    owner = "tlwg";
    repo = "fonts-tlwg";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-suA6jdCgvvWjfHkQhPRE87jm4U/72Acb+U+/O1tDsbI=";
  };

  nativeBuildInputs = [
    autoreconfHook
    autoconf-archive
  ];

  buildInputs = [ fontforge ];

  meta = {
    description = "Collection of Thai scalable fonts available under free licenses";
    homepage = "https://linux.thai.net/projects/fonts-tlwg";
    license = with lib.licenses; [
      gpl2
      publicDomain
      lppl13c
      free
    ];
    maintainers = [ lib.maintainers.yrashk ];
  };
})
