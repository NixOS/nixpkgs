{ stdenv, fetchFromGitHub
, gcc-arm-embedded, python2
, skipTargets ? [
  # These targets do not build, for the reasons listed, along with the last version checked.
  # Probably all of the issues with these targets need to be addressed upstream.
  "AG3X"       # 3.4.0-rc4: has not specified a valid STM group, must be one of F1, F3, F405, F411 or F7x5. Have you prepared a valid target.mk?
  "ALIENWHOOP" # 3.4.0-rc4: has not specified a valid STM group, must be one of F1, F3, F405, F411 or F7x5. Have you prepared a valid target.mk?
  "FURYF3"     # 3.4.0-rc4: flash region overflow
  "OMNINXT"    # 3.4.0-rc4: has not specified a valid STM group, must be one of F1, F3, F405, F411 or F7x5. Have you prepared a valid target.mk?
]}:

let

  version = "3.4.0-rc4";

in stdenv.mkDerivation rec {

  name = "betaflight-${version}";

  src = fetchFromGitHub {
    owner = "betaflight";
    repo = "betaflight";
    rev = "8e9e7574481b1abba9354b24f41eb31054943785"; # Always use a commit id here!
    sha256 = "1wyp23p876xbfi9z6gm4xn1nwss3myvrjjjq9pd3s0vf5gkclkg5";
  };

  buildInputs = [
    gcc-arm-embedded
    python2
  ];

  postPatch = ''
    sed -ri "s/REVISION.*=.*git log.*/REVISION = ${builtins.substring 0 10 src.rev}/" Makefile # Simulate abbrev'd rev.
    sed -ri "s/binary hex/hex/" Makefile # No need for anything besides .hex
  '';

  enableParallelBuilding = true;

  preBuild = ''
    buildFlagsArray=(
      "NOBUILD_TARGETS=${toString skipTargets}"
      "GCC_REQUIRED_VERSION=$(arm-none-eabi-gcc -dumpversion)"
      all
    )
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp obj/*.hex $out

    runHook postInstall
  '';

  meta = with stdenv.lib; {
    description = "Flight controller software (firmware) used to fly multi-rotor craft and fixed wing craft";
    homepage = https://github.com/betaflight/betaflight;
    license = licenses.gpl3;
    maintainers = with maintainers; [ elitak ];
    platforms = [ "i686-linux" "x86_64-linux" ];
  };

}
