{
  kdeApp, lib, kdeWrapper,

  ecm, kdoctools, makeWrapper,

  karchive, kconfig, kcrash, kdbusaddons, ki18n, kiconthemes, khtml, kio,
  kservice, kpty, kwidgetsaddons, libarchive,

  # Archive tools
  p7zip, unrar, unzipNLS, zip,

  # CVE fixe
  fetchpatch
}:

let
  unwrapped =
    kdeApp {
      name = "ark";
      nativeBuildInputs = [
        ecm kdoctools makeWrapper
      ];
      propagatedBuildInputs = [
        khtml ki18n kio karchive kconfig kcrash kdbusaddons kiconthemes kservice
        kpty kwidgetsaddons libarchive
      ];
      patches = [
        (fetchpatch { # CVE-2017-5330
          url = "https://github.com/KDE/ark/commit/49ce94df19607e234525afda5ad4190ce35300c3.patch";
          sha256 = "06yvdn6m6fniyc798wbdyc9bzma230xafylx39bz9mhzfnypvfj8";
        })
      ];
      postInstall =
        let
          PATH = lib.makeBinPath [
            p7zip unrar unzipNLS zip
          ];
        in ''
          wrapProgram "$out/bin/ark" \
              --prefix PATH : "${PATH}"
        '';
      meta = {
        license = with lib.licenses; [ gpl2 lgpl3 ];
        maintainers = [ lib.maintainers.ttuegel ];
      };
    };
in
kdeWrapper unwrapped
{
  targets = [ "bin/ark" ];
}
