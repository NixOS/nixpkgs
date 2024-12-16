{
  lib,
  stdenv,
  fetchFromGitHub,
  nodejs_22,
  pnpm,
}:

let
  version = "0.0.27";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "tailwindcss-language-server";
  inherit version;

  src = fetchFromGitHub {
    owner = "tailwindlabs";
    repo = "tailwindcss-intellisense";
    rev = "@tailwindcss/language-server@v${finalAttrs.version}";
    hash = "sha256-FphKiGMTMQj/tBmrwkPVlb+dEGjf+N4EgZtOVg7iL2M=";
  };

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs)
      pname
      version
      src
      pnpmWorkspaces
      prePnpmInstall
      ;
    hash = "sha256-kLB84P2Zb3gXpNlXCnQFIxz8xibACB39URIhy6Na9p8=";
  };

  nativeBuildInputs = [
    nodejs_22
    pnpm.configHook
  ];

  buildInputs = [ nodejs_22 ];

  pnpmWorkspaces = [ "@tailwindcss/language-server..." ];
  prePnpmInstall = ''
    # Warning section for "pnpm@v8"
    # https://pnpm.io/cli/install#--filter-package_selector
    pnpm config set dedupe-peer-dependents false
  '';

  buildPhase = ''
    runHook preBuild

    # Must build the "@tailwindcss/language-service" package. Dependency is linked via workspace by "pnpm"
    # (https://github.com/tailwindlabs/tailwindcss-intellisense/blob/%40tailwindcss/language-server%40v0.0.27/pnpm-lock.yaml#L47)
    pnpm --filter "@tailwindcss/language-server..." build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,lib/tailwindcss-language-server}
    cp -r {packages,node_modules} $out/lib/tailwindcss-language-server
    ln -s $out/lib/tailwindcss-language-server/packages/tailwindcss-language-server/bin/tailwindcss-language-server $out/bin/tailwindcss-language-server

    runHook postInstall
  '';

  meta = with lib; {
    description = "Tailwind CSS Language Server";
    homepage = "https://github.com/tailwindlabs/tailwindcss-intellisense";
    license = licenses.mit;
    maintainers = with maintainers; [ happysalada ];
    mainProgram = "tailwindcss-language-server";
    platforms = platforms.all;
  };
})
