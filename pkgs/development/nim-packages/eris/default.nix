<<<<<<< HEAD
{ lib, buildNimPackage, fetchFromGitea, pkg-config, base32, coap, cbor
, freedesktop_org, illwill, syndicate, tkrzw }:

buildNimPackage (final: prev: {
  pname = "eris";
  version = "20230722";
=======
{ lib, buildNimPackage, fetchFromGitea, pkg-config
, base32, coap, cbor, freedesktop_org, syndicate, tkrzw }:

buildNimPackage rec {
  pname = "eris";
  version = "20230201";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  outputs = [ "bin" "out" ];
  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "eris";
<<<<<<< HEAD
    repo = "nim-eris";
    rev = final.version;
    hash = "sha256-JVl2/PmFVYuD4s9hKoQwVDKUa3PBWK5SBDEmVHVSuig=";
  };
  propagatedNativeBuildInputs = [ pkg-config ];
  propagatedBuildInputs =
    [ base32 coap cbor freedesktop_org illwill tkrzw ];
  postInstall = ''
    mkdir -p "$bin/share/recoll/filters"
    mv "$bin/bin/rclerislink" "$bin/share/recoll/filters/"

=======
    repo = "nim-${pname}";
    rev = version;
    hash = "sha256-6vlD/woqTkbSRWhRtQD/ynk0DG+GrGwh6x+qUmo6YSQ=";
  };
  propagatedNativeBuildInputs = [ pkg-config ];
  propagatedBuildInputs = [
    base32
    coap
    cbor
    freedesktop_org
    syndicate
    tkrzw
  ];
  postInstall = ''
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    mkdir -p "$bin/share/applications"
    substitute "eris-open.desktop" "$bin/share/applications/eris-open.desktop"\
      --replace "Exec=eriscmd " "Exec=$bin/bin/eriscmd "

    install -D "eris-link.xml" -t "$bin/share/mime/packages"
    install -D "eris48.png" "$bin/share/icons/hicolor/48x48/apps/eris.png"
  '';
<<<<<<< HEAD
  meta = final.src.meta // {
    homepage = "https://codeberg.org/eris/nim-eris";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ ehmry ];
    mainProgram = "eriscmd";
    badPlatforms = lib.platforms.darwin;
  };
})
=======
  meta = src.meta // {
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ ehmry ];
    mainProgram = "eriscmd";
  };
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
