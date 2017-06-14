{ stdenv, fetchFromGitHub, mono, fsharp, dotnetPackages, z3, ocamlPackages, openssl, makeWrapper, pkgconfig, file }:

stdenv.mkDerivation rec {
  name = "fstar-${version}";
  version = "0.9.4.0";

  src = fetchFromGitHub {
    owner = "FStarLang";
    repo = "FStar";
    rev = "v${version}";
    sha256 = "130779p5plsgvz0dkcqycns3vwrvyfl138nq2xdhd3rkdsbyyvb7";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = with ocamlPackages; [
    mono fsharp z3 dotnetPackages.FsLexYacc ocaml findlib ocaml_batteries
    zarith camlp4 yojson pprint openssl pkgconfig file
  ];

  preBuild = ''
    substituteInPlace src/Makefile --replace "\$(RUNTIME) VS/.nuget/NuGet.exe" "true" \
      --replace Darwin xyz
    substituteInPlace src/VS/.nuget/NuGet.targets --replace "mono" "true"

    # Fails with bad interpreter otherwise
    patchShebangs src/tools
    patchShebangs bin

    export FSharpTargetsPath="$(dirname $(pkg-config FSharp.Core --variable=Libraries))/Microsoft.FSharp.Targets"
    # remove hardcoded windows paths
    sed -i '/<FSharpTargetsPath/d' src/*/*.fsproj

    mkdir -p src/VS/packages/FsLexYacc.6.1.0
    ln -s ${dotnetPackages.FsLexYacc}/lib/dotnet/FsLexYacc src/VS/packages/FsLexYacc.6.1.0/build
  '';

  makeFlags = [
    "FSYACC=${dotnetPackages.FsLexYacc}/bin/fsyacc"
    "FSLEX=${dotnetPackages.FsLexYacc}/bin/fslex"
    "NUGET=true"
    "PREFIX=$(out)"
  ];

  buildFlags = "-C src";

  # Now that the .NET fstar.exe is built, use it to build the native OCaml binary
  postBuild = ''
    patchShebangs bin/fstar.exe

    # Workaround for fsharp/fsharp#419
    cp ${fsharp}/lib/mono/4.5/FSharp.Core.dll bin/

    # Use the built .NET binary to extract the sources of itself from F* to OCaml
    make ''${enableParallelBuilding:+-j''${NIX_BUILD_CORES} -l''${NIX_BUILD_CORES}} \
        $makeFlags "''${makeFlagsArray[@]}" \
        ocaml -C src

    # Build the extracted OCaml sources
    make ''${enableParallelBuilding:+-j''${NIX_BUILD_CORES} -l''${NIX_BUILD_CORES}} \
        $makeFlags "''${makeFlagsArray[@]}" \
        -C src/ocaml-output
  '';

  # https://github.com/FStarLang/FStar/issues/676
  doCheck = false;

  preCheck = "ulimit -s unlimited";

  # Basic test suite:
  #checkFlags = "VERBOSE=y -C examples";

  # Complete, but heavyweight test suite:
  checkTarget = "regressions";
  checkFlags = "VERBOSE=y -C src";

  installFlags = "-C src/ocaml-output";

  postInstall = ''
    wrapProgram $out/bin/fstar.exe --prefix PATH ":" "${z3}/bin"
  '';

  meta = with stdenv.lib; {
    description = "ML-like functional programming language aimed at program verification";
    homepage = "https://www.fstar-lang.org";
    license = licenses.asl20;
    platforms = with platforms; darwin ++ linux;
  };
}
