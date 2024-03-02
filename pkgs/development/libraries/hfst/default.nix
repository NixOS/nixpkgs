{ lib
, autoreconfHook
, bison
, flex
, foma
, fetchFromGitHub
, gettext
, icu
, stdenv
, swig
, pkg-config
, zlib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hfst";
  version = "3.16.0";

  src = fetchFromGitHub {
    owner = "hfst";
    repo = "hfst";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-2ST0s08Pcp+hTn7rUTgPE1QkH6PPWtiuFezXV3QW0kU=";
  };

  nativeBuildInputs = [
    autoreconfHook
    bison
    flex
    pkg-config
    swig
  ];

  buildInputs = [
    foma
    gettext
    icu
    zlib
  ];

  configureFlags = [
    "--enable-all-tools"
    "--with-foma-upstream=true"
  ];

  meta = with lib; {
    description = "FST language processing library";
    homepage = "https://github.com/hfst/hfst";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ lurkki ];
    platforms = platforms.unix;
  };
})
