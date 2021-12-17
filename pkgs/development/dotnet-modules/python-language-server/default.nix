{ lib
, stdenv
, fetchFromGitHub
, buildDotnetModule
, dotnetCorePackages
, autoPatchelfHook
, openssl
, icu
}:

buildDotnetModule rec {
  pname = "python-language-server";
  version = "2021-09-08";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "python-language-server";
    rev = "26ea18997f45f7d7bc5a3c5a9efc723a8dbb02fa";
    sha256 = "1m8pf9k20wy4fzv27v3bswvc8s01ag6ka2qm9nn6bgq0s0lq78mh";
  };

  projectFile = "src/LanguageServer/Impl/Microsoft.Python.LanguageServer.csproj";
  nugetDeps = ./deps.nix;

  dotnet-sdk = dotnetCorePackages.sdk_3_1;
  dotnet-runtime = dotnetCorePackages.runtime_3_1;

  nativeBuildInputs = [ autoPatchelfHook ];
  buildInputs = [ stdenv.cc.cc.lib ];
  runtimeDeps = [ openssl icu ];

  postFixup = ''
    mv $out/bin/Microsoft.Python.LanguageServer $out/bin/python-language-server
  '';

  passthru.updateScript = ./updater.sh;

  meta = with lib; {
    description = "Microsoft Language Server for Python";
    homepage = "https://github.com/microsoft/python-language-server";
    license = licenses.asl20;
    maintainers = with maintainers; [ thomasjm ];
    platforms = [ "x86_64-linux" ];
  };
}
