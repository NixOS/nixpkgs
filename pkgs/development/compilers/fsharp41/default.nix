# Temporaririly avoid dependency on dotnetbuildhelpers to avoid rebuilding many times while working on it

{ stdenv, fetchurl, pkgconfig, autoconf, automake, which, mono, dotnetbuildhelpers, dotnetPackages }:

stdenv.mkDerivation rec {
  name = "fsharp-${version}";
  version = "4.1.7";

  src = fetchurl {
    url = "https://github.com/fsharp/fsharp/archive/${version}.tar.gz";
    sha256 = "0rfkrk4mzi4w54mfqilvng9ar5swhmnwhsyjc54rx3fd0np3jiyl";
  };

  buildInputs = [
    pkgconfig
    autoconf
    automake
    which
    mono
    dotnetbuildhelpers
    dotnetPackages.FsCheck262
    dotnetPackages.FSharpCompilerTools
    dotnetPackages.FSharpCore
    dotnetPackages.FSharpData225
    dotnetPackages.FsLexYacc704
    dotnetPackages.MicrosoftDiaSymReader
    dotnetPackages.MicrosoftDiaSymReaderPortablePdb
    dotnetPackages.NUnit350
    dotnetPackages.SystemCollectionsImmutable131
    dotnetPackages.SystemReflectionMetadata
    dotnetPackages.SystemValueTuple
  ];

  configurePhase = ''
    substituteInPlace ./autogen.sh --replace "/usr/bin/env sh" "/bin/sh"
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
    ln -s ${dotnetPackages.FSharpCompilerTools}/lib/dotnet/FSharp.Compiler.Tools packages/FSharp.Compiler.Tools.4.1.4
    ln -s ${dotnetPackages.FSharpCore}/lib/dotnet/FSharp.Core/ packages/FSharp.Core.4.0.0.1
    ln -s ${dotnetPackages.FSharpData225}/lib/dotnet/FSharp.Data/ packages/FSharp.Data.2.2.5
    ln -s ${dotnetPackages.FsLexYacc704}/lib/dotnet/FsLexYacc/ packages/FsLexYacc.7.0.4
    ln -s ${dotnetPackages.MicrosoftDiaSymReader}/lib/dotnet/Microsoft.DiaSymReader/ packages/Microsoft.DiaSymReader.1.1.0
    ln -s ${dotnetPackages.MicrosoftDiaSymReaderPortablePdb}/lib/dotnet/Microsoft.DiaSymReader.PortablePdb/ packages/Microsoft.DiaSymReader.PortablePdb.1.2.0
    ln -s ${dotnetPackages.NUnit350}/lib/dotnet/NUnit/ packages/NUnit.3.5.0
    ln -s ${dotnetPackages.SystemCollectionsImmutable131}/lib/dotnet/System.Collections.Immutable/ packages/System.Collections.Immutable.1.3.1
    ln -s ${dotnetPackages.SystemReflectionMetadata}/lib/dotnet/System.Reflection.Metadata/ packages/System.Reflection.Metadata.1.4.2
    ln -s ${dotnetPackages.SystemValueTuple}/lib/dotnet/System.ValueTuple/ packages/System.ValueTuple.4.3.0
  '';

  # Make sure the executables use the right mono binary,
  # and set up some symlinks for backwards compatibility.
  postInstall = ''
    substituteInPlace $out/bin/fsharpc --replace " mono " " ${mono}/bin/mono "
    substituteInPlace $out/bin/fsharpi --replace " mono " " ${mono}/bin/mono "
    substituteInPlace $out/bin/fsharpiAnyCpu --replace " mono " " ${mono}/bin/mono "
    ln -s $out/bin/fsharpc $out/bin/fsc
    ln -s $out/bin/fsharpi $out/bin/fsi
    for dll in "$out/lib/mono/fsharp"/FSharp*.dll
    do
      create-pkg-config-for-dll.sh "$out/lib/pkgconfig" "$dll"
    done
  '';

  # To fix this error when running:
  # The file "/nix/store/path/whatever.exe" is an not a valid CIL image
  dontStrip = true;

  meta = {
    description = "A functional CLI language";
    homepage = "http://fsharp.org/";
    license = stdenv.lib.licenses.asl20;
    maintainers = with stdenv.lib.maintainers; [ thoughtpolice raskin ];
    platforms = with stdenv.lib.platforms; unix;
  };
}
