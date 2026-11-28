{
  cctools,
  darwin,
  fetchFromGitHub,
  makeWrapper,
}:

darwin.sigtool.overrideAttrs (old: rec {
  # this is a fork of sigtool that supports -v and --remove-signature, which are
  # used by the dotnet sdk
  version = "0.2.3-new-commands";

  src = fetchFromGitHub {
    owner = "corngood";
    repo = "sigtool";
    rev = "v${version}";
    hash = "sha256-E7kVPJhEtVjth3pAWZtWg7iXxVmlGVoqTI06FhvlADE=";
  };

  nativeBuildInputs = old.nativeBuildInputs or [ ] ++ [
    makeWrapper
  ];

  postInstall = old.postInstall or "" + ''
    wrapProgram $out/bin/codesign \
      --set-default CODESIGN_ALLOCATE \
        "${cctools}/bin/${cctools.targetPrefix}codesign_allocate"
  '';
})
