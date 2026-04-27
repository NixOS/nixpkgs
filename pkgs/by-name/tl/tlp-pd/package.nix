{
  lib,
  python3Packages,
  tlp,
  coreutils,
}:

python3Packages.buildPythonApplication {
  pname = "tlp-pd";
  inherit (tlp)
    version
    src
    patches
    postPatch
    ;

  pyproject = false; # Built with make

  dependencies = with python3Packages; [
    pygobject3
    dbus-python
  ];

  makeFlags = [ "DESTDIR=${placeholder "out"}" ];

  installTargets = [
    "install-pd"
    "install-man-pd"
  ];

  makeWrapperArgs = [ "--prefix PATH : ${lib.makeBinPath [ tlp ]}" ];

  postInstall = ''
    substituteInPlace $out/share/dbus-1/system-services/*.service \
      --replace-fail "/bin/false" "${coreutils}/false"
  '';

  checkPhase = ''
    runHook preCheck

    # The program will error out but at least we are not missing python deps
    ($out/bin/tlpctl --help 2>&1 || true) |\
      grep -q 'g-io-error-quark: Could not connect: No such file or directory'
    $out/bin/tlp-pd --help

    runHook postCheck
  '';

  meta = {
    inherit (tlp.meta)
      homepage
      changelog
      platforms
      maintainers
      license
      ;
    description = "Power-rofiles-daemon like DBus interface for TLP";
    mainProgram = "tlp-pd";
  };
}
