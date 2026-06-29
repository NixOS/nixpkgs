{
  lib,
  stdenv,
  fetchurl,
  gzip,
  lzip,
  nix-update-script,
  testers,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zutils";
  version = "1.15";

  src = fetchurl {
    url = "mirror://savannah/zutils/${finalAttrs.pname}-${finalAttrs.version}.tar.lz";
    hash = "sha256-BeawPzM+q9eKEFUTlVforaa2NPGljoUB87jxEacFy4c=";
  };

  # Flake (tdata): mixed‑stream input triggers EPIPE during zcat’s internal teardown;
  # depending on timing the feeder returns non‑zero (EPIPE) instead of SIGPIPE→0 handled by child_status,
  # even though output is complete. Ignore that and let the following `cmp` assert bytes.
  postPatch = ''
    substituteInPlace testsuite/check.sh --replace-fail \
      'cat in.lz in in in in | "''${ZCAT}" -N > out || test_failed $LINENO	# tdata' \
      'cat in.lz in in in in | "''${ZCAT}" -N > out || : # tdata'
  '';

  enableParallelBuilding = true;

  nativeBuildInputs = [ lzip ];

  doCheck = true;

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/zcat";
  versionCheckProgramArg = "--version";

  passthru = {
    updateScript = nix-update-script { };

    tests = {
      zgrep = testers.runCommand {
        name = "zutils-zgrep";
        buildInputs = [
          finalAttrs.finalPackage
          gzip
        ];
        script = ''
          echo hello > message.txt
          gzip -1 message.txt
          zgrep -q hello message.txt.gz
          touch $out
        '';
      };
    };
  };

  meta = {
    description = "Collection of utilities that transparently operate on compressed data";
    homepage = "https://www.nongnu.org/zutils/zutils.html";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ Zaczero ];
  };
})
