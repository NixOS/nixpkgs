{ lib
, stdenv
, autoreconfHook
, fetchFromGitHub
, icu
, libarchive
, pkg-config
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hfst-ospell";
  version = "0.5.3";

  src = fetchFromGitHub {
    owner = "hfst";
    repo = "hfst-ospell";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-16H1nbAIe+G71+TnlLG0WnH9LktZwmc0d0O+oYduH1k=";
  };

  buildInputs = [
    icu
    libarchive
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  # libxmlxx is listed as a dependency but Darwin build fails with it,
  # might also be better in general since libxmlxx in Nixpkgs is 8 years old
  # https://github.com/hfst/hfst-ospell/issues/48#issuecomment-546535653
  configureFlags = [
    "--without-libxmlpp"
    "--without-tinyxml2"
  ];

  meta = with lib; {
    homepage = "https://github.com/hfst/hfst-ospell/";
    description = "HFST spell checker library and command line tool ";
    license = licenses.asl20;
    maintainers = with maintainers; [ lurkki ];
    platforms = platforms.unix;
  };
})
