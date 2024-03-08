{ lib
, fetchFromGitHub
, buildNpmPackage
, plasma-framework
}:

# how to update:
# 1. check out the tag for the version in question
# 2. run `prefetch-npm-deps package-lock.json`
# 3. update npmDepsHash with the output of the previous step

buildNpmPackage rec {
  pname = "polonium";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "zeroxoneafour";
    repo = pname;
    rev = "v" + version;
    hash = "sha256-fZgNOcOq+owmqtplwnxeOIQpWmrga/WitCNCj89O5XA=";
  };

  npmDepsHash = "sha256-25AtM1FweWIbFot+HUMSPYTu47/0eKNpRWSlBEL0yKk=";

  dontConfigure = true;

  # the installer does a bunch of stuff that fails in our sandbox, so just build here and then we
  # manually do the install
  buildFlags = [ "res" "src" ];

  nativeBuildInputs = [ plasma-framework ];

  dontNpmBuild = true;

  dontWrapQtApps = true;

  installPhase = ''
    runHook preInstall

    plasmapkg2 --install pkg --packageroot $out/share/kwin/scripts

    runHook postInstall
  '';

  meta = with lib; {
    description = "Auto-tiler that uses KWin 5.27+ tiling functionality";
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
    inherit (plasma-framework.meta) platforms;
  };
}
