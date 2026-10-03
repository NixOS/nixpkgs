{
  lib,
  stdenv,
  fetchFromGitHub,
  which,
}:

stdenv.mkDerivation rec {
  pname = "l-smash";
  version = "2.14.5";

  src = fetchFromGitHub {
    owner = "l-smash";
    repo = "l-smash";
    rev = "v${version}";
    hash = "sha256-AiyCiKSjkrxvkpJqW2Ddjbb+1//zLKQaatPUeMRJmGU=";
  };

  nativeBuildInputs = [ which ];

  configureFlags = [
    "--cc=cc"
    "--cross-prefix=${stdenv.cc.targetPrefix}"
  ];

  meta = {
    homepage = "http://l-smash.github.io/l-smash/";
    description = "MP4 container utilities";
    license = lib.licenses.isc;
    maintainers = [ ];
    platforms = lib.platforms.all;
    # The last successful Darwin Hydra build was in 2023
    broken = stdenv.hostPlatform.isDarwin;
  };
}
