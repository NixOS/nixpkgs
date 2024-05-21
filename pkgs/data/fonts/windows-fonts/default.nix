{
  lib,
  stdenvNoCC,
  fetchurl,
  p7zip,
  # To select only certain languages, put a list of strings to `languages`: every key in
  # ./${pname}-languages.nix is an optional language
  languages ? [ ],
}:
let
  windows-fonts =
    {
      pname,
      version,
      url,
      sha256,
      desc,
    }:
    let
      languageFonts = import ./${pname}-languages.nix;
      knownLanguageFonts = builtins.attrNames languageFonts;
      selectedLanguages =
        if (languages == [ ]) then
          [ "default" ]
        else
          let
            unknown = lib.subtractLists knownLanguageFonts languages;
          in
          if (unknown != [ ]) then
            throw "Unknown language(s): ${lib.concatStringsSep " " unknown}"
          else
            languages;
      selectedLanguageFonts = lib.attrsets.genAttrs selectedLanguages (fName: languageFonts."${fName}");
      selectedFonts = lib.lists.unique (builtins.concatLists (builtins.attrValues selectedLanguageFonts));
      fontPaths = builtins.concatStringsSep " " (map (font: "Windows/Fonts/" + font) selectedFonts);
    in
    stdenvNoCC.mkDerivation {
      inherit pname version desc;

      src = fetchurl { inherit url sha256; };

      nativeBuildInputs = [ p7zip ];

      unpackPhase = ''
        7z x $src
        7z x -aoa sources/install.wim Windows/{Fonts/"*".{ttf,ttc},System32/Licenses/neutral/"*"/"*"/license.rtf}
      '';

      installPhase = ''
        runHook preInstall

        install -Dm644 ${fontPaths} -t $out/share/fonts/opentype
        install -Dm644 Windows/System32/Licenses/neutral/*/*/license.rtf -t $out/share/licenses

        runHook postInstall
      '';

      meta = {
        description = "Some TrueType fonts from ${desc} (Arial, Bahnschrift, Calibri, Cambria, Candara, Consolas, Constantia...)";
        homepage = "https://learn.microsoft.com/typography/";
        license = lib.licenses.unfree;
        maintainers = with lib.maintainers; [ sobte ];

        # Set a non-zero priority to allow easy overriding of the
        # fontconfig configuration files.
        priority = 5;
      };
    };
in
{
  windows11 = windows-fonts {
    pname = "windows11-fonts";
    version = "10.0.22631.2428-2";
    url = "https://software-static.download.prss.microsoft.com/dbazure/888969d5-f34g-4e03-ac9d-1f9786c66749/22631.2428.231001-0608.23H2_NI_RELEASE_SVC_REFRESH_CLIENTENTERPRISEEVAL_OEMRET_x64FRE_en-us.iso";
    sha256 = "sha256-yNvJa2HQTIsB+vbOB5T98zllx7NQ6qPrHmaXAZkClFw=";
    desc = "Microsoft Windows 11 fonts";
  };
  windows10 = windows-fonts {
    pname = "windows10-fonts";
    version = "10.0.19045.2006-1";
    url = "https://software-static.download.prss.microsoft.com/dbazure/988969d5-f34g-4e03-ac9d-1f9786c66750/19045.2006.220908-0225.22h2_release_svc_refresh_CLIENTENTERPRISEEVAL_OEMRET_x86FRE_en-us.iso";
    sha256 = "sha256-bqeKy1+ojCwJdfZ2zEbKWTtDUYPIFbinxWHlbOkaajk=";
    desc = "Microsoft Windows 10 fonts";
  };
}
