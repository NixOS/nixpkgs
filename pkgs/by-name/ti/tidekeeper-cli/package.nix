{
  lib,
  python3Packages,
  fetchFromGitHub,
  nix-update-script,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "tidekeeper-cli";
  version = "v2026.5.17.4";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "OpenNerdz";
    repo = "tidekeeper-cli";
    rev = "v2026.5.16.7";
    hash = "sha256-OXKnsIkQwJKSPSldUpR1q+iXbDVp8u5eb6I4BruSxPg=";
  };
  sourceRoot = "./source/TIDALDL-PY/";
  propagatedBuildInputs = with python3Packages; [ aigpy ];
  passthru.updateScript = nix-update-script { };

  __structuredAttrs = true;

  meta = {
    homepage = "https://github.com/OpenNerdz/tidekeeper-cli";
    description = "Fork of Tidal-DL; an application that lets you download videos and tracks from Tidal.";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.xeni ];
    platforms = lib.platforms.all;
    mainProgram = "tidekeeper-cli";
  };
})
