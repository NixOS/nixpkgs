{
  fetchFromGitHub,
  buildDotnetModule,
  dotnetCorePackages,
  fontconfig,
  gtk3,
  libICE,
  lib,
  libSM,
  libX11,
}:

buildDotnetModule rec {
  pname = "uabea";
  version = "7";

  src = fetchFromGitHub {
    owner = "nesrak1";
    repo = "UABEA";
    rev = "v${version}";
    hash = "sha256-fwXf2VV2LMGYY8Rv35E3/LNwoUdTCgBQZtsC4K++ong=";
  };

  projectFile = "UABEAvalonia.sln";
  nugetDeps = ./deps.nix;

  executables = [ "UABEAvalonia" ];
  runtimeDeps = [
    fontconfig
    libICE
    libSM
    libX11
    gtk3
  ];

  preConfigure = ''
    # Broken on non-Windows
    dotnet sln UABEAvalonia.sln remove TexToolWrap/TexToolWrap.vcxproj

    #Save config file on Environment.SpecialFolder.ApplicationData
    configFile="UABEAvalonia/Config/ConfigurationManager.cs"
    sed -i '15 a\System.IO.Directory.CreateDirectory(Path.GetDirectoryName(configPath));' $configFile
    substituteInPlace $configFile \
      --replace-fail 'AppDomain.CurrentDomain.BaseDirectory' \
      'Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData), "UABEA"'
  '';

  postFixup = ''
    # Avalonia crashes with some locales.
    wrapProgram $out/bin/UABEAvalonia --set LC_ALL C

    #Move plguins manually
    cd $out/lib/uabea
    mv AudioClipPlugin.dll Fmod5Sharp.dll FontPlugin.dll TexturePlugin.dll \
    NAudio.Core.dll OggVorbisEncoder.dll System.Text.Json.dll TextAssetPlugin.dll \
    plugins
  '';

  meta = with lib; {
    homepage = "https://github.com/nesrak1/UABEA";
    description = "Unity Asset Bundle/Serialized File reader and writer";
    license = licenses.mit;
    mainProgram = "UABEAvalonia";
    maintainers = with lib.maintainers; [ fatimatooth ];
  };
}
