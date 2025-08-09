{
  lib,
  stdenv,
  fetchFromGitLab,
  callPackage,
  ensureNewerSourcesForZipFilesHook,
  python3,
  makeWrapper,
  # optional list of extra waf tools, e.g. `[ "doxygen" "pytest" ]`
  extraTools ? [ ],
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "waf";
  version = "2.1.6";

  src = fetchFromGitLab {
    owner = "ita1024";
    repo = "waf";
    rev = "waf-${finalAttrs.version}";
    hash = "sha256-srBBRe7OLNM86OVJYYk6A0EYJi+rdJ/xG7f+YBdrclE=";
  };

  nativeBuildInputs = [
    ensureNewerSourcesForZipFilesHook
    python3
    makeWrapper
  ];

  buildInputs = [
    # waf executable uses `#!/usr/bin/env python`
    python3
  ];

  strictDeps = true;

  configurePhase = ''
    runHook preConfigure

    python waf-light configure

    runHook postConfigure
  '';

  buildPhase =
    let
      extraToolsList = lib.optionalString (
        extraTools != [ ]
      ) "--tools=\"${lib.concatStringsSep "," extraTools}\"";
    in
    ''
      runHook preBuild

      python waf-light build ${extraToolsList}

      substituteInPlace waf \
        --replace "w = test(i + '/lib/' + dirname)" \
                  "w = test('$out/${python3.sitePackages}')"

      runHook postBuild
    '';

  installPhase = ''
    runHook preInstall

    install -D waf "$out"/bin/waf
    wrapProgram "$out"/bin/waf --prefix PYTHONPATH : "$out"/${python3.sitePackages}
    mkdir -p "$out"/${python3.sitePackages}/
    cp -r waflib "$out"/${python3.sitePackages}/
    runHook postInstall
  '';

  passthru = {
    inherit python3 extraTools;
    hook = callPackage ./hook.nix {
      waf = finalAttrs.finalPackage;
    };
  };

  meta = {
    homepage = "https://waf.io";
    description = "Meta build system";
    changelog = "https://gitlab.com/ita1024/waf/blob/waf-${finalAttrs.version}/ChangeLog";
    license = lib.licenses.bsd3;
    mainProgram = "waf";
    maintainers = with lib.maintainers; [ ];
    inherit (python3.meta) platforms;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
  };
})
