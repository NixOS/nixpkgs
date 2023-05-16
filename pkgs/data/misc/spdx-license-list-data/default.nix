{ stdenvNoCC, lib, fetchFromGitHub }:

stdenvNoCC.mkDerivation rec {
  pname = "spdx-license-list-data";
<<<<<<< HEAD
  version = "3.21";
=======
  version = "3.20";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "spdx";
    repo = "license-list-data";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-dv8aC4giD0JqaYN19eCHzEbmwXhqX+ZrKrwit9tzf5Y=";
=======
    hash = "sha256-qMVUP1EpeeO+i5RfnAt/Idz+pR9dVyCT4Ss9lEJgj6k=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  # List of file formats to package.
  _types = [ "html" "json" "jsonld" "rdfa" "rdfnt" "rdfturtle" "rdfxml" "template" "text" ];

  outputs = [ "out" ] ++ _types;

  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -pv $out
    for t in $_types
    do
      _outpath=''${!t}
      mkdir -pv $_outpath
      cp -ar $t $_outpath && echo "$t format installed"
    done

    runHook postInstall
  '';

  dontFixup = true;

  meta = with lib; {
    description = "Various data formats for the SPDX License List";
    homepage = "https://github.com/spdx/license-list-data";
    license = licenses.cc0;
    maintainers = with maintainers; [ oxzi c0bw3b ];
    platforms = platforms.all;
  };
}
