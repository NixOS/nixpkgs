{
  lib,
  stdenvNoCC,
  fetchurl,
  nixosTests,
  nix-update-script,
  php,
  ...
}:

let
  pname = "wallabag";
  version = "2.6.14";
in
stdenvNoCC.mkDerivation {
  inherit pname version;

  # Release tarball includes vendored files
  src = fetchurl {
    url = "https://github.com/wallabag/wallabag/releases/download/${version}/wallabag-${version}.tar.gz";
    hash = "sha256-AEk0WuxZfazo4r4shcK453RCF/4V/VMDvKs4EXGe/w0=";
  };

  patches = [
    ./wallabag.patch
  ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp -rv . $out

    runHook postInstall
  '';

  passthru = {
    updateScript = nix-update-script { };
    test = {
      inherit (nixosTests) wallabag;
    };
  };

  meta = {
    description = "Self-hostable application for saving web pages";
    longDescription = ''
      Wallabag is a self-hostable PHP application allowing you to not
      miss any content anymore. Click, save and read it when you can.
      It extracts content so that you can read it when you have time.
    '';
    license = lib.licenses.mit;
    homepage = "https://wallabag.org";
    changelog = "https://github.com/wallabag/wallabag/releases/tag/${version}";
    maintainers = with lib.maintainers; [ skowalak ];
    inherit (php.meta) platforms;
  };
}
