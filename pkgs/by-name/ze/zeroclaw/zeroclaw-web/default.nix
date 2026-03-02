{
  fetchFromGitHub,
  buildNpmPackage,
  version,
  ...
}:
buildNpmPackage (finalAttrs: {
  pname = "zeroclaw-web";
  inherit version;

  src = fetchFromGitHub {
    owner = "zeroclaw-labs";
    repo = "zeroclaw";
    tag = "v${finalAttrs.version}";
    hash = "sha256-D4/2h7TlOwAU4tl1xcdULRfO21KmP+zLlqQ8DzLqnjQ=";
  };

  sourceRoot = "${finalAttrs.src.name}/web";

  npmDepsHash = "sha256-H3extDaq4DgNYTUcw57gqwVWc3aPCWjIJEVYRMzdFdM=";

  installPhase = ''
    runHook preInstall

    cp -r dist $out

    runHook postInstall
  '';
})
