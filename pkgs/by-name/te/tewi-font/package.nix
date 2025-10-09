{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
  bdftopcf,
  xorg,
  libfaketime,
}:

stdenv.mkDerivation rec {
  pname = "tewi-font";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "lucy";
    repo = "tewi-font";
    rev = version;
    sha256 = "1axv9bv10xlcmgfyjh3z5kn5fkg3m6n1kskcs5hvlmyb6m1zk91j";
  };

  nativeBuildInputs = [
    python3
    bdftopcf
    xorg.mkfontscale
    libfaketime
    xorg.fonttosfnt
  ];

  postPatch = ''
    # make gzip deterministic
    sed 's/gzip -9/gzip -9 -n/g' -i Makefile

    # fix python not found
    patchShebangs scripts/merge
  '';

  postBuild = ''
    # convert bdf fonts to otb
    for i in *.bdf; do
      name=$(basename "$i" .bdf)
      faketime -f "1970-01-01 00:00:01" \
      fonttosfnt -v -o "$name.otb" "$i"
    done
  '';

  installPhase = ''
    fontDir="$out/share/fonts/misc"
    install -m 644 -D *.otb out/* -t "$fontDir"
    mkfontdir "$fontDir"
  '';

  meta = with lib; {
    description = "Nice bitmap font, readable even at small sizes";
    longDescription = ''
      Tewi is a bitmap font, readable even at very small font sizes. This is
      particularily useful while programming, to fit a lot of code on your
      screen.
    '';
    homepage = "https://github.com/lucy/tewi-font";
    license = {
      fullName = "GNU General Public License with a font exception";
      url = "https://www.gnu.org/licenses/gpl-faq.html#FontException";
    };
    maintainers = [ maintainers.fro_ozen ];
  };
}
