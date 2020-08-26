# Temporaririly avoid dependency on dotnetbuildhelpers to avoid rebuilding many times while working on it

{ stdenv, fetchurl, pkgconfig, autoconf, automake, which, mono, msbuild, dotnetbuildhelpers, dotnetPackages }:

stdenv.mkDerivation rec {
  pname = "fsharp";
  version = "4.1.34";

  src = fetchurl {
    url = "https://github.com/fsharp/fsharp/archive/${version}.tar.gz";
    sha256 = "0cv6p5pin962vhbpsji40nkckkag5c96kq5qihvg60pc1z821p0i";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    autoconf
    automake
    which
    mono
    msbuild
    dotnetbuildhelpers
    dotnetPackages.FsCheck262
    dotnetPackages.FSharpCompilerTools
    dotnetPackages.FSharpCore302
    dotnetPackages.FSharpCore3125
    dotnetPackages.FSharpCore4001
    dotnetPackages.FSharpCore4117
    dotnetPackages.FSharpData225
    dotnetPackages.FsLexYacc706
    dotnetPackages.MicrosoftDiaSymReader
    dotnetPackages.MicrosoftDiaSymReaderPortablePdb
    dotnetPackages.NUnit350
    dotnetPackages.SystemCollectionsImmutable131
    dotnetPackages.SystemReflectionMetadata
    dotnetPackages.SystemValueTuple
  ];

  # https://github.com/mono/mono/tree/fe0f311a848068ab2d17a9b9dd15326e5712d520/packaging/MacSDK/patches
  # https://github.com/mono/mono/issues/7805
  patches = [
    ./fsharp-IsPathRooted-type-inference.patch
    ./fsharp-string-switchName.patch
    ./fsharp-path-overloads.patch
  ];

  configurePhase = ''
    substituteInPlace ./autogen.sh --replace "/usr/bin/env sh" "${stdenv.shell}"
    ./autogen.sh --prefix $out
  '';

  preBuild = ''
    substituteInPlace Makefile --replace "MONO_ENV_OPTIONS=\$(monoopts) mono .nuget/NuGet.exe restore packages.config -PackagesDirectory packages -ConfigFile .nuget/NuGet.Config" "true"
    substituteInPlace src/fsharp/Fsc-proto/Fsc-proto.fsproj --replace "<FSharpCoreOptSigFiles Include=\"\$(FSharpCoreLkgPath)\\FSharp.Core.dll\" />" ""
    substituteInPlace src/fsharp/Fsc-proto/Fsc-proto.fsproj --replace "<FSharpCoreOptSigFiles Include=\"\$(FSharpCoreLkgPath)\\FSharp.Core.optdata\" />" ""
    substituteInPlace src/fsharp/Fsc-proto/Fsc-proto.fsproj --replace "<FSharpCoreOptSigFiles Include=\"\$(FSharpCoreLkgPath)\\FSharp.Core.sigdata\" />" ""
    substituteInPlace src/fsharp/Fsc-proto/Fsc-proto.fsproj --replace "<FSharpCoreOptSigFiles Include=\"\$(FSharpCoreLkgPath)\\FSharp.Core.xml\" />" ""

    rm -rf packages
    mkdir packages

    ln -s ${dotnetPackages.FsCheck262}/lib/dotnet/FsCheck packages/FsCheck.2.6.2
    ln -s ${dotnetPackages.FSharpCompilerTools}/lib/dotnet/FSharp.Compiler.Tools packages/FSharp.Compiler.Tools.4.1.27
    ln -s ${dotnetPackages.FSharpCore302}/lib/dotnet/FSharp.Core/ packages/FSharp.Core.3.0.2
    ln -s ${dotnetPackages.FSharpCore3125}/lib/dotnet/FSharp.Core/ packages/FSharp.Core.3.1.2.5
    ln -s ${dotnetPackages.FSharpCore4001}/lib/dotnet/FSharp.Core/ packages/FSharp.Core.4.0.0.1
    ln -s ${dotnetPackages.FSharpCore4117}/lib/dotnet/FSharp.Core/ packages/FSharp.Core.4.1.17
    ln -s ${dotnetPackages.FSharpData225}/lib/dotnet/FSharp.Data/ packages/FSharp.Data.2.2.5
    ln -s ${dotnetPackages.FsLexYacc706}/lib/dotnet/FsLexYacc/ packages/FsLexYacc.7.0.6
    ln -s ${dotnetPackages.MicrosoftDiaSymReader}/lib/dotnet/Microsoft.DiaSymReader/ packages/Microsoft.DiaSymReader.1.1.0
    ln -s ${dotnetPackages.MicrosoftDiaSymReaderPortablePdb}/lib/dotnet/Microsoft.DiaSymReader.PortablePdb/ packages/Microsoft.DiaSymReader.PortablePdb.1.2.0
    ln -s ${dotnetPackages.NUnit350}/lib/dotnet/NUnit/ packages/NUnit.3.5.0
    ln -s ${dotnetPackages.SystemCollectionsImmutable131}/lib/dotnet/System.Collections.Immutable/ packages/System.Collections.Immutable.1.3.1
    ln -s ${dotnetPackages.SystemReflectionMetadata}/lib/dotnet/System.Reflection.Metadata/ packages/System.Reflection.Metadata.1.4.2
    ln -s ${dotnetPackages.SystemValueTuple}/lib/dotnet/System.ValueTuple/ packages/System.ValueTuple.4.3.1
  '';

  # Signing /home/jdanek/nix/nixpkgs/build/fss/fsharp-4.1.34/again/fsharp-4.1.34/Release/fsharp30/net40/bin/FSharp.Core.dll with Mono key
  # ERROR: Unknown error during processing: System.UnauthorizedAccessException: Access to the path
  #   "Release/fsharp30/net40/bin/FSharp.Core.dll" is denied.
  preInstall = ''
    find Release/ -name FSharp.Core.dll -exec chmod u+w {} \;
  '';

  # Set up some symlinks for backwards compatibility.
  postInstall = ''
    ln -s $out/bin/fsharpc $out/bin/fsc
    ln -s $out/bin/fsharpi $out/bin/fsi
    for dll in "$out/lib/mono/fsharp"/FSharp*.dll
    do
      create-pkg-config-for-dll.sh "$out/lib/pkgconfig" "$dll"
    done
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    echo 'printf "int = %i" (6 * 7);;' > script.fsx
    $out/bin/fsi --exec script.fsx | grep "int = 42"
    $out/bin/fsharpi --exec script.fsx | grep "int = 42"
    $out/bin/fsharpiAnyCpu --exec script.fsx | grep "int = 42"

    cat > answer.fs <<EOF
open System

[<EntryPoint>]
let main argv =
    printfn "int = %i" (6 * 7)
    0
EOF

    $out/bin/fsc answer.fs
    ${mono}/bin/mono answer.exe | grep "int = 42"
  '';

  # To fix this error when running:
  # The file "/nix/store/path/whatever.exe" is an not a valid CIL image
  dontStrip = true;

  meta = {
    description = "A functional CLI language";
    homepage = "https://fsharp.org/";
    license = stdenv.lib.licenses.asl20;
    maintainers = with stdenv.lib.maintainers; [ thoughtpolice raskin ];
    platforms = with stdenv.lib.platforms; unix;
  };
}
