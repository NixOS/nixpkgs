{ lib
, buildDotnetModule
, fetchFromGitHub
, dotnetCorePackages
, fetchpatch
}:

buildDotnetModule rec {
  pname = "torrentstream";
  version = "1.0.1.6";

  src = fetchFromGitHub {
    owner = "trueromanus";
    repo = "TorrentStream";
    rev = version;
    hash = "sha256-41zlzrQ+YGY2wEvq4Su/lp6lOmGW4u0F37ub2a3z+7o=";
  };

  sourceRoot = "source/src";

  projectFile = "TorrentStream.sln";
  nugetDeps = ./deps.nix;
  dotnet-sdk = dotnetCorePackages.sdk_7_0;
  dotnet-runtime = dotnetCorePackages.aspnetcore_7_0;
  executables = [ "TorrentStream" ];

  patches = [
    (fetchpatch {
       name = "allow-setting-listen-address.patch";
       url = "https://github.com/trueromanus/TorrentStream/compare/1.0.1.6..6900b6f33f2b4b94888a8a1355029a81767e66a4.patch";
       hash = "sha256-jOUs5SO2BnNnkz3wJ710Z4stVlhZ8nKqpmHr4BNlGs0=";
       stripLen = 1;
       excludes = [ "README.md" ];
     })
    ./0001-display-the-message-of-caught-exceptions.patch
  ];

  meta = {
    homepage = "https://github.com/trueromanus/TorrentStream";
    description = "Simple web server for streaming torrent files in video players";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.all;
    mainProgram = "TorrentStream";
    maintainers = with lib.maintainers; [ _3JlOy-PYCCKUi ];
  };
}
