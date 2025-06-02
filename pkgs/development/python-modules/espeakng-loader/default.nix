{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchzip,
  hatchling,
}:

let
  espeak-ng-data = fetchzip {
    url = "https://github.com/thewh1teagle/espeakng-loader/releases/download/v1.51/espeak-ng-data.tar.gz";
    hash = "sha256-svGVYg2tY0QQ9vL+1428mlYeSohZU6IKa51NTy8ugiI=";
  };
in
buildPythonPackage {
  pname = "espeakng-loader";
  version = "0.9.4-unstable-2025-01-17";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "thewh1teagle";
    repo = "espeakng-loader";
    rev = "146599e29be31bf17d99f0bcb7dbb2f92aef3d95";
    hash = "sha256-YlqlC5/x54y2nz2o4InCXOy802VE2VEDl7SRr3sBcTk=";
  };

  postPatch = ''
    cp -r ${espeak-ng-data} src/espeakng_loader/espeak-ng-data
  '';

  build-system = [ hatchling ];

  pythonImportsCheck = [ "espeakng_loader" ];

  meta = {
    description = "Provides shared library loader for eSpeak NG";
    homepage = "https://github.com/thewh1teagle/espeakng-loader";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ emaryn ];
  };
}
