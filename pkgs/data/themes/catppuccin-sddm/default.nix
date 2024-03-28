{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  just,
  qtsvg,
  qtquickcontrols2,
  flavor ? "mocha",
  font ? "Noto Sans",
  fontSize ? "9",
  background ? null,
  loginBackground ? false,
}:
stdenvNoCC.mkDerivation rec {
  pname = "catppuccin-sddm";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "catppuccin";
    repo = "sddm";
    rev = "v${version}";
    hash = "sha256-SdpkuonPLgCgajW99AzJaR8uvdCPi4MdIxS5eB+Q9WQ=";
  };

  dontWrapQtApps = true;

  buildInputs = [
    just
  ];

  propagatedBuildInputs = [
    qtsvg
    qtquickcontrols2
  ];

  buildPhase = ''
    just build
  '';

  installPhase = ''
    mkdir -p "$out/share/sddm/themes/"
    cp -r dist/catppuccin-${flavor} "$out/share/sddm/themes/catppuccin-${flavor}"

    configFile=$out/share/sddm/themes/catppuccin-${flavor}/theme.conf

    substituteInPlace $configFile \
      --replace-fail 'Font="Noto Sans"' 'Font="${font}"' \
      --replace-fail 'FontSize=9' 'FontSize=${fontSize}'

    ${lib.optionalString (background != null) ''
      substituteInPlace $configFile \
        --replace-fail 'Background="backgrounds/wall.jpg"' 'Background="${background}"' \
        --replace-fail 'CustomBackground="false"' 'CustomBackground="true"'
    ''}

    ${lib.optionalString loginBackground ''
      substituteInPlace $configFile \
        --replace-fail 'LoginBackground="false"' 'LoginBackground="true"'
    ''}
  '';

  postFixup = ''
    mkdir -p $out/nix-support
    echo ${qtsvg} >> $out/nix-support/propagated-user-env-packages
    echo ${qtquickcontrols2} >> $out/nix-support/propagated-user-env-packages
  '';

  meta = {
    description = "Soothing pastel theme for SDDM";
    homepage = "https://github.com/catppuccin/sddm";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [elysasrc];
    platforms = lib.platforms.linux;
  };
}
