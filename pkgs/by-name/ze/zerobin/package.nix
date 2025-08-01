{
  lib,
  python3Packages,
  fetchFromGitHub,
  uglify-js,
}:

python3Packages.buildPythonApplication rec {
  pname = "zerobin";
  version = "1.0.5";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "Tygs";
    repo = "0bin";
    rev = "v${version}";
    sha256 = "1dfy3h823ylz4w2vv3mrmnmiyvf6rvyvsp4j3llr074w9id0zy16";
  };

  disabled = python3Packages.pythonOlder "3.7";

  nativeBuildInputs = [
    python3Packages.doit
    python3Packages.pyscss
    uglify-js
  ];

  propagatedBuildInputs = with python3Packages; [
    appdirs
    beaker
    bleach
    bottle
    clize
    lockfile
    paste
  ];

  prePatch = ''
    # replace /bin/bash in compress.sh
    patchShebangs .

    # relax version constraints of some dependencies
    substituteInPlace setup.cfg \
      --replace "clize==4.1.1" "clize" \
      --replace "bleach==3.1.5" "bleach>=3.1.5,<6" \
      --replace "bottle==0.12.18" "bottle>=0.12.18,<1" \
      --replace "Paste==3.4.3" "Paste>=3.4.3,<4"
  '';

  buildPhase = ''
    runHook preBuild
    doit build
    runHook postBuild
  '';

  # zerobin has no check, but checking would fail with:
  # nix_run_setup runserver: Received extra arguments: test
  # See https://github.com/NixOS/nixpkgs/pull/98734#discussion_r495823510
  doCheck = false;

  pythonImportsCheck = [ "zerobin" ];

  meta = with lib; {
    description = "Client side encrypted pastebin";
    homepage = "https://0bin.net/";
    license = licenses.wtfpl;
    platforms = platforms.all;
    maintainers = with maintainers; [ julm ];
  };
}
