{ lib, stdenv
, fetchFromGitHub
, fetchurl
, mono
, dotnet-sdk_5
, makeWrapper
, dotnetPackages
, unzip
, writeText
, symlinkJoin
}:

let

  deps = map (package: stdenv.mkDerivation (with package; {
    inherit pname version src;

    buildInputs = [ unzip ];
    unpackPhase = ''
      unzip -o $src
      chmod -R u+r .
      function traverseRename () {
        for e in *
        do
          t="$(echo "$e" | sed -e "s/%20/\ /g" -e "s/%2B/+/g")"
          [ "$t" != "$e" ] && mv -vn "$e" "$t"
          if [ -d "$t" ]
          then
            cd "$t"
            traverseRename
            cd ..
          fi
        done
      }

      traverseRename
    '';

    installPhase = ''
      runHook preInstall

      package=$out/lib/dotnet/${pname}/${version}
      mkdir -p $package
      cp -r . $package
      echo "{}" > $package/.nupkg.metadata

      runHook postInstall
    '';

    dontFixup = true;
  }))
    (import ./deps.nix { inherit fetchurl; });

  nuget-config = writeText "NuGet.Config" ''
    <?xml version="1.0" encoding="utf-8"?>
    <configuration>
      <packageSources>
        <clear />
      </packageSources>
    </configuration>
  '';

  packages = symlinkJoin { name = "roslyn-deps"; paths = deps; };

  packageVersion = "3.10.0";

in stdenv.mkDerivation rec {

  pname = "roslyn";
  version = "${packageVersion}-1.21102.26";

  src = fetchFromGitHub {
    owner = "dotnet";
    repo = "roslyn";
    rev = "v${version}";
    sha256 = "0yf4f4vpqn9lixr37lkp29m2mk51xcm3ysv2ag332xn6zm5zpm2b";
  };

  nativeBuildInputs = [ makeWrapper dotnet-sdk_5 unzip ];

  buildPhase = ''
    runHook preBuild

    rm NuGet.config
    install -m644 -D ${nuget-config} fake-home/.nuget/NuGet/NuGet.Config
    ln -s ${packages}/lib/dotnet fake-home/.nuget/packages
    HOME=$(pwd)/fake-home dotnet msbuild -r -v:m -t:pack \
      -p:Configuration=Release \
      -p:RepositoryUrl="${meta.homepage}" \
      -p:RepositoryCommit="v${version}" \
      src/NuGet/Microsoft.Net.Compilers.Toolset/Microsoft.Net.Compilers.Toolset.Package.csproj

    runHook postBuild
  '';

  installPhase = ''
    pkg=$out/lib/dotnet/microsoft.net.compilers.toolset/${packageVersion}
    mkdir -p $out/bin $pkg
    unzip -q artifacts/packages/Release/Shipping/Microsoft.Net.Compilers.Toolset.${packageVersion}-dev.nupkg \
      -d $pkg
    # nupkg has 0 permissions for a bunch of things
    chmod -R +rw $pkg

    makeWrapper ${mono}/bin/mono $out/bin/csc \
      --add-flags "$pkg/tasks/net472/csc.exe"
    makeWrapper ${mono}/bin/mono $out/bin/vbs \
      --add-flags "$pkg/tasks/net472/vbs.exe"
  '';

  meta = with lib; {
    description = ".NET C# and Visual Basic compiler";
    homepage = "https://github.com/dotnet/roslyn";
    platforms = platforms.linux;
    license = licenses.mit;
    maintainers = with maintainers; [ corngood ];
  };
}
