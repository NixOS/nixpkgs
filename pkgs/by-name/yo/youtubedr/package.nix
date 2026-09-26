{
  lib,
  buildGoModule,
  versionCheckHook,
  fetchFromGitHub,
}:

let
  # Disabled because tests rely on network requests
  disabledTests = [
    "TestTranscript"
    "TestSimpleTest"
    "TestGetPlaylist"
    "TestGetBigPlaylist"
    "TestDownload_SensitiveContent"
    "TestGetVideo_MultiLanguage"
    "TestParseVideo"
    "TestParse_PublishDate"
    "TestDownload_WhenPlayabilityStatusIsNotOK"
    "TestDownload_Regular"
    "TestYoutube_GetItagInfo"
    "TestClient_httpGetBodyBytes"
    "TestClient_httpGetBodyBytes"
    "TestGetStream"
    "TestGetVideoWithManifestURL"
    "TestWebClientGetVideoWithoutManifestURL"
    "TestGetVideoWithoutManifestURL"
    "TestClient_httpGetBodyBytes"
    "TestDownload_FirstStream"
  ];
in
buildGoModule (finalAttrs: {
  pname = "youtubedr";
  version = "2.10.6";

  src = fetchFromGitHub {
    owner = "kkdai";
    repo = "youtube";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rkkqLBH4P5DMrbfsZwVgBjnQG1/fHdjVL4mU6amYUxM=";
  };

  __structuredAttrs = true;

  vendorHash = "sha256-DIdDDS8U4UR3ZPmwqrhsOfejUJ4UHmwcr4JCpjkwOzs=";

  ldflags = [
    "-X main.version=${finalAttrs.version}"
  ];

  checkFlags = [
    "-skip=${lib.concatStringsSep "|" disabledTests}"
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  versionCheckProgramArg = "version";
  versionCheckKeepEnvironment = [ "HOME" ];
  doInstallCheck = true;

  meta = {
    homepage = "https://github.com/kkdai/youtube";
    description = "YouTube video download CLI";
    mainProgram = "youtubedr";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ligerothetiger ];
  };
})
