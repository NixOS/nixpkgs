{
  lib,
  python3Packages,
  fetchFromGitHub,
  nixosTests,
  wrapGAppsNoGuiHook,
  gobject-introspection,
  glib,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "targetcli-fb";
  version = "3.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "open-iscsi";
    repo = "targetcli-fb";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ajBKlgnXeksvEkewo93PIeqwI9X90NvLNf6YxzC0824=";
  };

  build-system = with python3Packages; [
    hatch-vcs
    hatchling
  ];

  nativeBuildInputs = [
    wrapGAppsNoGuiHook
    gobject-introspection
  ];
  buildInputs = [ glib ];

  dependencies = with python3Packages; [
    configshell-fb
    rtslib-fb
    pygobject3
  ];

  postInstall = ''
    install -D targetcli.8 -t $out/share/man/man8/
    install -D targetclid.8 -t $out/share/man/man8/
  '';

  passthru.tests = {
    inherit (nixosTests) iscsi-root;
  };

  meta = {
    description = "Command shell for managing the Linux LIO kernel target";
    homepage = "https://github.com/open-iscsi/targetcli-fb";
    changelog = "https://github.com/open-iscsi/targetcli-fb/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = [ ];
    platforms = lib.platforms.linux;
    mainProgram = "targetcli";
  };
})
