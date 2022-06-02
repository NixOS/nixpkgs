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
  version = "2022-02-18";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "python-language-server";
    rev = "52c1afd34b5acb0b44597bb8681232876fe94084";
    sha256 = "05s8mwi3dqzjghgpr1mfs1b7cgrq818bbj1v7aly6axc8c2n4gny";
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
