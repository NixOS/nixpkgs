{
  lib,
  buildGoModule,
  fetchFromGitHub,
  runtimeShell,
  udevCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "xe-guest-utilities";
  version = "10.0.1";

  src = fetchFromGitHub {
    owner = "xenserver";
    repo = "xe-guest-utilities";
    rev = "v${finalAttrs.version}";
    hash = "sha256-KUcsCk5ll+fjLS3HORHB6lirFMgGSNZBorgNPUFKW9Y=";
  };

  nativeBuildInputs = [
    udevCheckHook
  ];

  doInstallCheck = true;

  deleteVendor = true;
  vendorHash = "sha256-YhgCs5iYvY34EWh/bl47Dr3Nrfi55QK4T7i47C77B9w=";

  postPatch = ''
    substituteInPlace mk/xen-vcpu-hotplug.rules \
      --replace "/bin/sh" "${runtimeShell}"
  '';

  buildPhase = ''
    runHook preBuild

    make RELEASE=nixpkgs

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dt "$out"/bin build/stage/usr/{,s}bin/*
    install -Dt "$out"/etc/udev/rules.d build/stage/etc/udev/rules.d/*

    runHook postInstall
  '';

  meta = {
    description = "XenServer guest utilities";
    homepage = "https://github.com/xenserver/xe-guest-utilities";
    license = lib.licenses.bsd2;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
