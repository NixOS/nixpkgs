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
    hash = "sha256-WngnpsWSFMEetOQOd+uzyy7V1DFKyNgp/MvcqZrJ9gU=";
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
