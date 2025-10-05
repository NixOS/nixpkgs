{
  stdenv,
  lib,
  idris2,
  makeBinaryWrapper,
}:
# Usage: let
#          pkg = idris2Packages.buildIdris {
#            src = ...;
#            ipkgName = "my-pkg";
#            idrisLibraries = [ ];
#          };
#        in {
#          lib1 = pkg.library { withSource = true; };
#
#          # implicitly without source:
#          lib2 = pkg.library';
#
#          bin = pkg.executable;
#        }
#
{
  src,
  ipkgName, # ipkg filename without the extension
  version ? "unversioned",
  idrisLibraries, # Other libraries built with buildIdris
  ...
}@attrs:

let
  # loop over idrisLibraries and normalize them by turning any that are
  # direct outputs of the buildIdris function into the `.library {}`
  # property.
  idrisLibraryLibs = map (
    idrisLib:
    if lib.isDerivation idrisLib then
      idrisLib
    else if builtins.isFunction idrisLib then
      idrisLib { }
    else if (builtins.isAttrs idrisLib && idrisLib ? "library") then
      idrisLib.library { }
    else
      throw "Found an Idris2 library dependency that was not the result of the buildIdris function"
  ) idrisLibraries;

  propagate =
    libs: lib.unique (lib.concatMap (nextLib: [ nextLib ] ++ nextLib.propagatedIdrisLibraries) libs);
  ipkgFileName = ipkgName + ".ipkg";
  idrName = "idris2-${idris2.version}";
  libSuffix = "lib/${idrName}";
  libDirs = libs: (lib.makeSearchPath libSuffix libs) + ":${idris2}/${idrName}";
  supportDir = "${idris2}/${idrName}/lib";
  drvAttrs = removeAttrs attrs [
    "ipkgName"
    "idrisLibraries"
  ];

  mkDerivation =
    withSource:
    let
      applyWithSource = lib: if withSource then lib.withSource else lib;
      propagatedIdrisLibraries = map applyWithSource (propagate idrisLibraryLibs);
    in
    stdenv.mkDerivation (
      finalAttrs:
      drvAttrs
      // {
        pname = ipkgName;
        inherit src version;
        nativeBuildInputs = [
          idris2
          makeBinaryWrapper
        ]
        ++ attrs.nativeBuildInputs or [ ];
        buildInputs = propagatedIdrisLibraries ++ attrs.buildInputs or [ ];

        env.IDRIS2_PACKAGE_PATH = libDirs propagatedIdrisLibraries;

        buildPhase = ''
          runHook preBuild
          idris2 --build ${ipkgFileName}
          runHook postBuild
        '';

        passthru = {
          inherit propagatedIdrisLibraries;
        }
        // (attrs.passthru or { });

        shellHook = ''
          export IDRIS2_PACKAGE_PATH="${finalAttrs.env.IDRIS2_PACKAGE_PATH}"
        '';
      }
    );

  mkExecutable =
    withSource:
    let
      derivation = mkDerivation withSource;
    in
    derivation.overrideAttrs {
      installPhase = ''
        runHook preInstall
        mkdir -p $out/bin
        scheme_app="$(find ./build/exec -name '*_app')"
        if [ "$scheme_app" = ''' ]; then
          mv -- build/exec/* $out/bin/
          chmod +x $out/bin/*
          # ^ remove after Idris2 0.8.0 is released. will be superfluous:
          # https://github.com/idris-lang/Idris2/pull/3189
        else
          cd build/exec/*_app
          rm -f ./libidris2_support.{so,dylib}
          for file in *.so; do
            bin_name="''${file%.so}"
            mv -- "$file" "$out/bin/$bin_name"

            wrapProgram "$out/bin/$bin_name" \
              --prefix LD_LIBRARY_PATH : ${supportDir} \
              --prefix DYLD_LIBRARY_PATH : ${supportDir}
          done
        fi
        runHook postInstall
      '';

      # allow an executable's dependencies to be built with source. this is convenient when
      # building a development shell for the executable using `mkShell`'s `inputsFrom`.
      passthru = derivation.passthru // {
        withSource = mkExecutable true;
      };
    };

  mkLibrary =
    withSource:
    let
      installCmd = if withSource then "--install-with-src" else "--install";
      derivation = mkDerivation withSource;
    in
    derivation.overrideAttrs {
      installPhase = ''
        runHook preInstall
        mkdir -p $out/${libSuffix}
        export IDRIS2_PREFIX=$out/lib
        idris2 ${installCmd} ${ipkgFileName}
        runHook postInstall
      '';

      # allow a library built without source to be changed to one with source
      # via a passthru attribute; i.e. `my-pkg.library'.withSource`.
      # this is convenient because a library derivation can be distributed as
      # without-source by default but downstream projects can still build it
      # with-source. We surface this regardless of whether the original library
      # was built with source because that allows downstream to call this
      # property unconditionally.
      passthru = derivation.passthru // {
        withSource = mkLibrary true;
      };
    };

in
{
  executable = mkExecutable false;

  library =
    {
      withSource ? false,
    }:
    mkLibrary withSource;

  # Make a library without source; you can still use the `withSource` attribute
  # on the resulting derivation to build the library with source at a later time.
  library' = mkLibrary false;
}
