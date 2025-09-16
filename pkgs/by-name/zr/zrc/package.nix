{
  lib,
  stdenv,
  fetchFromGitHub,
  bison,
  flex,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zrc";
  version = "2.3";

  src = fetchFromGitHub {
    owner = "Edd12321";
    repo = "zrc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BJlMrafyPmA7vMEf31ao88HLbU86tySTbtuCaN4RxtY=";
  };

  nativeBuildInputs = [
    bison
    flex
  ];

  makeFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "UNIX shell and scripting language with syntax similar to Tcl";
    homepage = "https://github.com/Edd12321/zrc";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ fgaz ];
    mainProgram = "zrc";
    platforms = lib.platforms.all;
    broken = stdenv.hostPlatform.isDarwin;
  };
})
