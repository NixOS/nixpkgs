{ lib, buildNimPackage, fetchFromGitea, pkg-config, base32, coap, cbor
, freedesktop_org, illwill, syndicate, tkrzw }:

buildNimPackage rec {
  pname = "eris";
  version = "20230716";
  outputs = [ "bin" "out" ];
  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "eris";
    repo = "nim-${pname}";
    rev = version;
    hash = "sha256-g2mxua4++zqKeMbe98nBWh7/+rN/IElIiPcvyX0nfEY=";
  };
  propagatedNativeBuildInputs = [ pkg-config ];
  propagatedBuildInputs =
    [ base32 coap cbor freedesktop_org illwill syndicate tkrzw ];
  postInstall = ''
    mkdir -p "$bin/share/recoll/filters"
    mv "$bin/bin/rclerislink" "$bin/share/recoll/filters/"

    mkdir -p "$bin/share/applications"
    substitute "eris-open.desktop" "$bin/share/applications/eris-open.desktop"\
      --replace "Exec=eriscmd " "Exec=$bin/bin/eriscmd "

    install -D "eris-link.xml" -t "$bin/share/mime/packages"
    install -D "eris48.png" "$bin/share/icons/hicolor/48x48/apps/eris.png"
  '';
  preCheck = "rm tests/test_syndicate.nim";
  meta = src.meta // {
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ ehmry ];
    mainProgram = "eriscmd";
    badPlatforms = lib.platforms.darwin;
  };
}
