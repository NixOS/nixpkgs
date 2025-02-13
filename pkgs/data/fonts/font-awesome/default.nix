{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:
let
  font-awesome =
    {
      version,
      hash,
      rev ? version,
    }:
    stdenvNoCC.mkDerivation {
      pname = "font-awesome";
      inherit version;

      src = fetchFromGitHub {
        owner = "FortAwesome";
        repo = "Font-Awesome";
        inherit rev hash;
      };

      installPhase = ''
        runHook preInstall

        install -m444 -Dt $out/share/fonts/opentype {fonts,otfs}/*.otf

        runHook postInstall
      '';

      meta = with lib; {
        description = "Font Awesome - OTF font";
        longDescription = ''
          Font Awesome gives you scalable vector icons that can instantly be customized.
          This package includes only the OTF font. For full CSS etc. see the project website.
        '';
        homepage = "https://fontawesome.com/";
        license = licenses.ofl;
        platforms = platforms.all;
        maintainers = with maintainers; [
          abaldeau
          johnazoidberg
        ];
      };
    };
in
{
  # Keeping version 4 and 5 because version 6 is incompatible for some icons. That
  # means that projects which depend on it need to actively convert the
  # symbols. See:
  # https://github.com/greshake/i3status-rust/issues/130
  # https://fontawesome.com/how-to-use/on-the-web/setup/upgrading-from-version-4
  # https://fontawesome.com/v6/docs/web/setup/upgrade/
  v4 = font-awesome {
    version = "4.7.0";
    rev = "v4.7.0";
    hash = "sha256-LL9zWFC+76wH74nqKszPQf2ZDfXq8BiH6tuiK43wYHA=";
  };
  v5 = font-awesome {
    version = "5.15.4";
    hash = "sha256-gd23ZplNY56sm1lfkU3kPXUOmNmY5SRnT0qlQZRNuBo=";
  };
  v6 = font-awesome {
    version = "6.7.1";
    hash = "sha256-Lzy12F0qEGzvdyN9SC3nyh2eTc80HM4qR5U6h0G15bo=";
  };
}
