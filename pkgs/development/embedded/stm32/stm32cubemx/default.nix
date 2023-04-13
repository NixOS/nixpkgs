{ lib, stdenv, makeDesktopItem, copyDesktopItems, icoutils, fdupes, imagemagick, jdk11, fetchzip }:
# TODO: JDK16 causes STM32CubeMX to crash right now, so we fixed the version to JDK11
# This may be fixed in a future version of STM32CubeMX. This issue has been reported to ST:
# https://community.st.com/s/question/0D53W00000jnOzPSAU/stm32cubemx-crashes-on-launch-with-openjdk16
# If you're updating this derivation, check the link above to see if it's been fixed upstream
# and try replacing all occurrences of jdk11 with jre and test whether it works.
let
  iconame = "STM32CubeMX";
in
stdenv.mkDerivation rec {
  pname = "stm32cubemx";
  version = "6.8.0";

  src = fetchzip {
    url = "https://sw-center.st.com/packs/resource/library/stm32cube_mx_v${builtins.replaceStrings ["."] [""] version}-lin.zip";
    sha256 = "sha256-jJeJTg2cCO6fqQ4vFq2dXsfsWmlN5ncZJWMoekJXkLQ=";
    stripRoot = false;
  };

  nativeBuildInputs = [ icoutils fdupes imagemagick copyDesktopItems];
  desktopItems = [
    (makeDesktopItem {
      name = "stm32CubeMX";
      exec = "stm32cubemx";
      desktopName = "STM32CubeMX";
      categories = [ "Development" ];
      comment = "STM32Cube initialization code generator";
      icon = "stm32cubemx";
    })
  ];

  buildCommand = ''
    mkdir -p $out/{bin,opt/STM32CubeMX}
    cp -r $src/MX/. $out/opt/STM32CubeMX/
    chmod +rx $out/opt/STM32CubeMX/STM32CubeMX
    cat << EOF > $out/bin/${pname}
    #!${stdenv.shell}
    ${jdk11}/bin/java -jar $out/opt/STM32CubeMX/STM32CubeMX
    EOF
    chmod +x $out/bin/${pname}

    icotool --extract $out/opt/STM32CubeMX/help/${iconame}.ico
    fdupes -dN . > /dev/null
    ls
    for size in 16 24 32 48 64 128 256; do
      mkdir -pv $out/share/icons/hicolor/"$size"x"$size"/apps
      if [ $size -eq 256 ]; then
        mv ${iconame}_*_"$size"x"$size"x32.png \
          $out/share/icons/hicolor/"$size"x"$size"/apps/${pname}.png
      else
        convert -resize "$size"x"$size" ${iconame}_*_256x256x32.png \
          $out/share/icons/hicolor/"$size"x"$size"/apps/${pname}.png
      fi
    done;
  '';

  meta = with lib; {
    description = "A graphical tool for configuring STM32 microcontrollers and microprocessors";
    longDescription = ''
      A graphical tool that allows a very easy configuration of STM32
      microcontrollers and microprocessors, as well as the generation of the
      corresponding initialization C code for the Arm® Cortex®-M core or a
      partial Linux® Device Tree for Arm® Cortex®-A core), through a
      step-by-step process.
    '';
    homepage = "https://www.st.com/en/development-tools/stm32cubemx.html";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.unfree;
    maintainers = with maintainers; [ wucke13 ];
    platforms = platforms.all;
  };
}
