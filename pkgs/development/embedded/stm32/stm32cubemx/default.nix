{ lib, stdenv, makeDesktopItem, copyDesktopItems, icoutils, fdupes, imagemagick, jdk11, fetchzip }:
# TODO: Since be1392dbd9debfe1d9a72b6aeb01a7a3c625623f, this package uses JDK11 because there have
# been issues with JDK16 at that time. The issue that caused the program to crash at startup:
# https://community.st.com/s/question/0D53W00000jnOzPSAU/stm32cubemx-crashes-on-launch-with-openjdk16
# This seems to have been resolved but code generation to EWARM and MDK-ARM failed with JDK19 which
# was the newest JDK then..Therefore, JDK11 was kept.
# If you're updating this derivation, check if all issues with the newest JDK have been resolved by
# replacing all occurrences of jdk11 with jdk. If so, keep that change.
let
  iconame = "STM32CubeMX";
in
stdenv.mkDerivation rec {
  pname = "stm32cubemx";
  version = "6.7.0";

  src = fetchzip {
    url = "https://sw-center.st.com/packs/resource/library/stm32cube_mx_v${builtins.replaceStrings ["."] [""] version}-lin.zip";
    sha256 = "sha256-PX8Fw8XK4WXAs9oRDYS5exUTP74Bdkt7dA9sP8VpLzM=";
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
