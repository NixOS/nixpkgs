{
  lib,
  buildGoModule,
  fetchFromGitHub,
  stdenv,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "tsshd";
  version = "0.1.6";

  src = fetchFromGitHub {
    owner = "trzsz";
    repo = finalAttrs.pname;
    tag = "v${finalAttrs.version}";
    hash = "sha256-B5PTiz9luBxkDA9UMSkGYTcPbnXdL43rkFvbOUS5F6w=";
  };

  vendorHash = "sha256-dW05EoAVLqmiPRRG0R4KwKsSijZuxSe15iHkyCImtZY=";

  ldflags = [
    "-s"
    "-w"
  ];

  # Enable for upstream KCP and QUIC tests which require UDP binding on localhost
  __darwinAllowLocalNetworking = true;

  checkFlags =
    let
      skippedTests = [
        # `quic.DialAddr` of `quic-go` invokes UDP writing with `sendmsg` from address `[::]`,
        # causing these tests to fail even with the `__darwinAllowLocalNetworking` flag enabled.
        "TestQUIC_InitialPacketSize"
        "TestQUIC_RespectMTU"
        "TestQUIC_CertValidation"
      ];
    in
    lib.optionals stdenv.hostPlatform.isDarwin [
      "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$"
    ];

  doInstallCheck = true;
  nativeCheckInputs = [
    versionCheckHook
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Server for `trzsz-ssh`(`tssh`) that supports connection migration for roaming";
    homepage = "https://github.com/trzsz/tsshd";
    changelog = "https://github.com/trzsz/tsshd/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ljxfstorm ];
    mainProgram = "tsshd";
  };
})
