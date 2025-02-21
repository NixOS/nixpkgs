{ pkgs, lib, callPackage, ... }:

let
  inherit (builtins) filterSource;

  inherit (lib)
    commitIdFromGitRepo
    concatStringsSep
    elem
    elemAt
    hasSuffix
    listToAttrs
    mapAttrs
    optionalString
    pathExists
    readFile
    removeSuffix
    substring
    traceSeqN
    ;

  inherit (lib.strings) match;

  # Implicitly calls through to this file, similar to `let .. in` or `rec`.
  inherit (pkgs.gerbil-support)
    callPpp
    gerbilLoadPath
    gerbilPackage
    gerbilPackages-unstable
    gerbilSkippableFiles
    gerbilSourceFilter
    overrideSrcIfShaDiff
    ppaToPl
    pppToKV
    pppToName
    ppplToPpa
    prePackage-defaults
    prePackages-unstable
    resolve-pre-src
    sha256-of-pre-src
    view
    ;
in

{
  pppToName = ppp: removeSuffix ".nix" (baseNameOf ppp); # from pre-package path to name
  callPpp = ppp: callPackage ppp prePackage-defaults; # from pre-package path to pre-package
  pppToKV = ppp: { name = pppToName ppp; value = callPpp ppp; }; # from pre-package path to name
  ppplToPpa = ppps: listToAttrs (map pppToKV ppps); # from pre-package path list to name/pre-package attr

  prePackages-unstable =
    ppplToPpa
      [ ./gerbil-leveldb.nix ./gerbil-lmdb.nix ./gerbil-mysql.nix
        ./gerbil-libxml.nix ./gerbil-libyaml.nix
        ./smug-gerbil.nix # ./ftw.nix
        ./gerbil-utils.nix ./gerbil-crypto.nix ./gerbil-poo.nix
        ./gerbil-persist.nix ./gerbil-ethereum.nix
        # ./gerbil-libp2p.nix
        ./glow-lang.nix
      ];

  prePackage-defaults = {
    gerbil = pkgs.gerbil-unstable;
    gambit-params = pkgs.gambit-support.unstable-params;
    gerbilPackages = gerbilPackages-unstable;
    git-version = "";
    version-path = "";
    gerbilInputs = [];
    nativeBuildInputs = [];
    buildInputs = [];
    buildScript = "./build.ss";
    postInstall = "";
    softwareName = "";
  };

  ppaToPl = mapAttrs (_: gerbilPackage);
  gerbilPackages-unstable = ppaToPl prePackages-unstable;

  resolve-pre-src = pre-src: pre-src.fun (removeAttrs pre-src ["fun"]);

  gerbilVersionFromGit = srcDir: version-path:
    let version-file = "${srcDir}/${version-path}.ss"; in
    if pathExists version-file then
      let m =
        match "\\(import :clan/versioning.*\\)\n\\(register-software \"([-_.A-Za-z0-9]+)\" \"([-_.A-Za-z0-9]+)\"\\) ;; ([-0-9]+)\n"
          (readFile version-file); in
          { version = "${elemAt m 2}-git"; git-version = elemAt m 1; }
     else { version = "0.0-git";
            git-version = let gitpath = "${srcDir}/.git"; in
              if pathExists gitpath then commitIdFromGitRepo gitpath else "0"; };

  gerbilSkippableFiles = [".git" ".build" ".build_outputs" "run" "result" "dep" "BLAH" "tmp.nix"];

  gerbilSourceFilter = path: type:
    let baseName = baseNameOf path; in
      ! (elem baseName gerbilSkippableFiles || hasSuffix "~" baseName);

  gerbilFilterSource = filterSource gerbilSourceFilter;

  # Use this function in any package that uses Gerbil libraries, to define the GERBIL_LOADPATH.
  gerbilLoadPath =
    gerbilInputs: concatStringsSep ":" (map (x: x + "/gerbil/lib") gerbilInputs);

  path-src = path: { fun = _: path; };

  view = traceSeqN 4;

  sha256-of-pre-src = pre-src: if pre-src ? sha256 then pre-src.sha256 else "none";

  overrideSrcIfShaDiff = name: new-pre-src: super:
    let old-sha256 = sha256-of-pre-src super.${name}.pre-src;
        new-sha256 = sha256-of-pre-src new-pre-src; in
    if old-sha256 == new-sha256 then {} else
    view "Overriding ${name} old-sha256: ${old-sha256} new-sha256: ${new-sha256}"
    { ${name} = super.${name} // {
                       pre-src = new-pre-src;
                       version = "override";
                       git-version = if new-pre-src ? rev
                                     then substring 0 7 new-pre-src.rev
                                     else "unknown";};
                     };

  pkgsOverrideGerbilPackageSrc = name: pre-src: pkgs: super: {
    gerbil-support = (super-support:
      { prePackages-unstable =
          (super-ppu: super-ppu // (overrideSrcIfShaDiff name pre-src super-ppu))
          super-support.prePackages-unstable;}) super.gerbil-support;};

  # Use this function to create a Gerbil library. See gerbil-utils as an example.
  gerbilPackage = prePackage:
    let pre-pkg = prePackage-defaults // prePackage;
        inherit (pre-pkg) pname version pre-src git-version meta
          softwareName gerbil-package version-path gerbil gambit-params
          gerbilInputs nativeBuildInputs buildInputs buildScript postInstall;
        buildInputs_ = buildInputs; in
    pkgs.gccStdenv.mkDerivation rec { # See ../gambit/build.nix regarding why we use gccStdenv
      inherit meta pname version nativeBuildInputs postInstall;
      passthru = {
        inherit pre-pkg;
      };
      src = resolve-pre-src pre-src;
      buildInputs = [ gerbil ] ++ gerbilInputs ++ buildInputs_;

      postPatch = ''
        set -e ;
        ${optionalString (version-path != "")
          ''echo -e '(import :clan/versioning${concatStringsSep ""
                     (map (x: let px = x.passthru.pre-pkg; in
                              optionalString (px.version-path != "")
                                " :${px.gerbil-package}/${px.version-path}")
                          gerbilInputs)
                     })\n(register-software "${softwareName}" "v${git-version}")\n' > "${version-path}.ss"''}
        patchShebangs . ;
      '';

      postConfigure = ''
        export GERBIL_BUILD_CORES=$NIX_BUILD_CORES
        export GERBIL_PATH=$PWD/.build
        export GERBIL_LOADPATH=${gerbilLoadPath (["$out"] ++ gerbilInputs)}
        ${pkgs.gambit-support.export-gambopt gambit-params}
      '';

      buildPhase = ''
        runHook preBuild
        ${buildScript}
        runHook postBuild
      '';

      installPhase = ''
        runHook preInstall
        mkdir -p $out/gerbil
        cp -fa .build/* $out/gerbil/
        if [[ -d $out/gerbil/bin ]] ; then
          ( cd $out/gerbil
            bins=$(find ../gerbil/bin -type f)
            if [[ -n $bins ]] ; then
              ( mkdir -p ../bin
                cd ..
                ln -s $bins bin
              )
            fi
          )
        fi
        runHook postInstall
      '';

      dontFixup = true;

      checkPhase = ''
        runHook preCheck
        if [[ -f unit-tests.ss ]] ; then
          export GERBIL_APPLICATION_HOME=$PWD
          ./unit-tests.ss version
          ./unit-tests.ss
        else
          echo "No gerbil-utils style unit-tests.ss detected for ${pname} ${version}.";
        fi
        runHook postCheck
      '';

      doCheck = true;
    };
}
