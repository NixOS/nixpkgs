{
  lib,
  stdenv,
  fetchFromGitLab,
  buildEnv,
  makeWrapper,
  lua,
  luajit,
  readline,
  useLuaJit ? false,
  extraLibraries ? [ ],
}:

let
  version = "0.7.2";
  # Build a sort of "union package" with all the native dependencies we
  # have: Lua (or LuaJIT), readline, etc. Then, we can depend on this
  # and refer to ${urn-rt} instead of ${lua}, ${readline}, etc.
  urn-rt = buildEnv {
    name = "urn-rt-${version}";
    ignoreCollisions = true;
    paths =
      if useLuaJit then
        [
          luajit
          readline
        ]
      else
        [ lua ];
  };

  inherit (lib) optionalString concatMapStringsSep;
in

stdenv.mkDerivation {
  pname = "urn${optionalString (extraLibraries != [ ]) "-with-libraries"}";
  inherit version;

  src = fetchFromGitLab {
    owner = "urn";
    repo = "urn";
    rev = "v${version}";
    sha256 = "0nclr3d8ap0y5cg36i7g4ggdqci6m5q27y9f26b57km8p266kcpy";
  };

  nativeBuildInputs = [ makeWrapper ];
  # Any packages that depend on the compiler have a transitive
  # dependency on the Urn runtime support.
  propagatedBuildInputs = [ urn-rt ];

  makeFlags = [ "-B" ];

  installPhase = ''
    mkdir -p $out/bin $out/lib
    install -m 0755 bin/urn.lua $out/bin/urn
    cp -r lib $out/lib/urn
    wrapProgram $out/bin/urn \
      --add-flags "-i $out/lib/urn --prelude $out/lib/urn/prelude.lisp" \
      --add-flags "${concatMapStringsSep " " (x: "-i ${x.libraryPath}") extraLibraries}" \
      --prefix PATH : ${urn-rt}/bin/ \
      --prefix LD_LIBRARY_PATH : ${urn-rt}/lib/
  '';

  meta = with lib; {
    homepage = "https://urn-lang.com";
    description = "Yet another Lisp variant which compiles to Lua";
    mainProgram = "urn";
    license = licenses.bsd3;
    maintainers = [ ];
    platforms = platforms.all;
  };

  passthru = {
    inherit urn-rt;
  };
}
