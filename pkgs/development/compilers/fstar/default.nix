{ stdenv, fetchFromGitHub, mono, fsharp, dotnetPackages, z3, ocamlPackages, openssl, makeWrapper }:

stdenv.mkDerivation rec {
  name = "fstar-${version}";
  version = "0.9.2.0";

  src = fetchFromGitHub {
    owner = "FStarLang";
    repo = "FStar";
    rev = "v${version}";
    sha256 = "0vrxmxfaslngvbvkzpm1gfl1s34hdsprv8msasxf9sjqc3hlir3l";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = with ocamlPackages; [
    mono fsharp z3 dotnetPackages.FsLexYacc ocaml findlib ocaml_batteries openssl
  ];

  preBuild = ''
    substituteInPlace src/Makefile --replace "\$(RUNTIME) VS/.nuget/NuGet.exe" "true"

    source setenv.sh
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

  doCheck = true;

  preCheck = "ulimit -s unlimited";

  # Basic test suite:
  #checkFlags = "VERBOSE=y -C examples";

  # Complete, but heavyweight test suite:
  checkTarget = "regressions";
  checkFlags = "VERBOSE=y -C src";

  installFlags = "-C src/ocaml-output";

  postInstall = ''
    # Workaround for FStarLang/FStar#456
    mv $out/lib/fstar/* $out/lib/
    rmdir $out/lib/fstar

    wrapProgram $out/bin/fstar.exe --prefix PATH ":" "${z3}/bin"
  '';

  meta = with stdenv.lib; {
    description = "ML-like functional programming language aimed at program verification";
    homepage = "https://www.fstar-lang.org";
    license = licenses.asl20;
    platforms = with platforms; linux;
  };
}
