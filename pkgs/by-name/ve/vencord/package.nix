{ buildNpmPackage
, fetchFromGitHub
, lib
, esbuild
, buildWebExtension ? false
}:
let
  version = "1.9.0";
  gitHash = "3505ada";
in
buildNpmPackage rec {
  pname = "vencord";
  inherit version;

  src = fetchFromGitHub {
    owner = "Vendicated";
    repo = "Vencord";
    rev = "v${version}";
    hash = "sha256-H2LyZJPm5D6uUskJdpaESlO+/U9KWDrz8q+ZdgcyGr0=";
  };

  ESBUILD_BINARY_PATH = lib.getExe (esbuild.overrideAttrs (final: _: {
    version = "0.15.18";
    src = fetchFromGitHub {
      owner = "evanw";
      repo = "esbuild";
      rev = "v${final.version}";
      hash = "sha256-b9R1ML+pgRg9j2yrkQmBulPuLHYLUQvW+WTyR/Cq6zE=";
    };
    vendorHash = "sha256-+BfxCyg0KkDQpHt/wycy/8CTG6YBA/VJvJFhhzUnSiQ=";
  }));

  # Supresses an error about esbuild's version.
  npmRebuildFlags = [ "|| true" ];

  makeCacheWritable = true;
  npmDepsHash = "sha256-hTOaAtAyIfnOwirqP2y/2MIOXLsUmO7CkyJvebO7C34=";
  npmFlags = [ "--legacy-peer-deps" ];
  npmBuildScript = if buildWebExtension then "buildWeb" else "build";
  npmBuildFlags = [ "--" "--standalone" "--disable-updater" ];

  prePatch = ''
    cp ${./package-lock.json} ./package-lock.json
    chmod +w ./package-lock.json
  '';

  VENCORD_HASH = gitHash;
  VENCORD_REMOTE = "${src.owner}/${src.repo}";

  installPhase =
    if buildWebExtension then ''
      cp -r dist/chromium-unpacked/ $out
    '' else ''
      cp -r dist/ $out
    '';

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "Vencord web extension";
    homepage = "https://github.com/Vendicated/Vencord";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ FlafyDev NotAShelf Scrumplex ];
  };
}
