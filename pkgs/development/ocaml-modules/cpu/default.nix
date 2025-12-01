{
  lib,
  stdenv,
  buildDunePackage,
  fetchFromGitHub,
  autoconf,
}:

buildDunePackage (finalAttrs: {
  pname = "cpu";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "UnixJunkie";
    repo = "cpu";
    tag = "v${finalAttrs.version}";
    hash = "sha256-O0pvNRONlprQ4XVG3858cnDo0WDJWOaEfH3DFeAzOe4=";
  };

  preConfigure = ''
    autoconf
    autoheader
  '';

  nativeBuildInputs = [ autoconf ];

  hardeningDisable = lib.optional stdenv.hostPlatform.isDarwin "strictoverflow";

  meta = {
    homepage = "https://github.com/UnixJunkie/cpu";
    description = "Core pinning library";
    maintainers = [ lib.maintainers.bcdarwin ];
    license = lib.licenses.lgpl2;
  };
})
