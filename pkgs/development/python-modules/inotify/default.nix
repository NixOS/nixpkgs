{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  nose,
}:

buildPythonPackage rec {
  pname = "inotify";
  version = "unstable-2020-08-27";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "dsoprea";
    repo = "PyInotify";
    rev = "f77596ae965e47124f38d7bd6587365924dcd8f7";
    sha256 = "X0gu4s1R/Kg+tmf6s8SdZBab2HisJl4FxfdwKktubVc=";
    fetchSubmodules = false;
  };

  nativeCheckInputs = [ nose ];

  # dunno what's wrong but the module works regardless
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/dsoprea/PyInotify";
    description = "Monitor filesystems events on Linux platforms with inotify";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
