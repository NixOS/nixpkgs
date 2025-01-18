{
  lib,
  buildDotnetModule,
  fetchFromGitHub,
  dotnetCorePackages,
}:

buildDotnetModule rec {
  pname = "torrentstream";
  version = "1.0.1.11";

  src = fetchFromGitHub {
    owner = "trueromanus";
    repo = "TorrentStream";
    rev = version;
    hash = "sha256-3lmQWx00Ulp0ZyQBEhFT+djHBi84foMlWGJEp/UOGek=";
  };

  sourceRoot = "${src.name}/src";

  dotnet-runtime = dotnetCorePackages.aspnetcore_8_0;
  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  executables = [ "TorrentStream" ];
  nugetDeps = ./deps.json;
  projectFile = "TorrentStream.csproj";
  selfContainedBuild = true;

  dotnetFlags = [
    "-p:PublishAot=false" # untill https://github.com/NixOS/nixpkgs/issues/280923 is fixed
    "-p:PublishSingleFile=true"
  ];

  patches = [
    ./0001-display-the-message-of-caught-exceptions.patch
  ];

  meta = with lib; {
    homepage = "https://github.com/trueromanus/TorrentStream";
    description = "Simple web server for streaming torrent files in video players";
    license = licenses.bsd2;
    platforms = platforms.all;
    mainProgram = "TorrentStream";
    maintainers = with maintainers; [ _3JlOy-PYCCKUi ];
  };
}
