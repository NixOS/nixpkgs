{ stdenv, fetchFromGitHub
, gcc-arm-embedded, python2
, skipTargets ? [
  # These targets do not build for various unexplored reasons
  # TODO ... fix them
  "AFROMINI"
  "ALIENWHOOP"
  "BEEBRAIN"
  "CJMCU"
  "FRSKYF3"
]}:

let

  version = "3.2.3";

in stdenv.mkDerivation rec {

  name = "betaflight-${version}";

  src = fetchFromGitHub {
    owner = "betaflight";
    repo = "betaflight";
    rev = "v${version}";
    sha256 = "0vbjyxfjxgpaiiwvj5bscrlfikzp3wnxpmc4sxcz5yw5mwb9g428";
  };

  buildInputs = [
    gcc-arm-embedded
    python2
  ];

  postPatch = ''
    sed -ri "s/REVISION.*=.*git log.*/REVISION = ${builtins.substring 0 9 src.rev}/" Makefile # Let's not require git in shell
    sed -ri "s/binary hex/hex/" Makefile # No need for anything besides .hex
  '';

  enableParallelBuilding = true;

  preBuild = ''
    buildFlagsArray=(
      "SKIP_TARGETS=${toString skipTargets}"
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
    platforms = platforms.linux;
  };

}
