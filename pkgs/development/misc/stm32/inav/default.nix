{ lib, stdenv, fetchFromGitHub
, gcc-arm-embedded, binutils-arm-embedded, ruby
}:

let

  version = "2.0.0-rc2";

in stdenv.mkDerivation rec {

  pname = "inav";
  inherit version;

  src = fetchFromGitHub {
    owner = "iNavFlight";
    repo = "inav";
    rev = "a8415e89c2956d133d8175827c079bcf3bc3766c"; # Always use a commit id here!
    sha256 = "15zai8qf43b06fmws1sbkmdgip51zp7gkfj7pp9b6gi8giarzq3y";
  };

  nativeBuildInputs = [
    gcc-arm-embedded binutils-arm-embedded
    ruby
  ];

  postPatch = ''
    sed -ri "s/REVISION.*=.*shell git.*/REVISION = ${builtins.substring 0 10 src.rev}/" Makefile # Simulate abbrev'd rev.
    sed -ri "s/-j *[0-9]+//" Makefile # Eliminate parallel build args in submakes
    sed -ri "s/binary hex/hex/" Makefile # No need for anything besides .hex

    substituteInPlace Makefile \
      --replace "--specs=nano.specs" ""
  '';

  enableParallelBuilding = true;

  preBuild = ''
    buildFlagsArray=(
      all
    )
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp obj/*.hex $out

    runHook postInstall
  '';

  meta = with lib; {
    description = "Navigation-enabled flight control software";
    homepage = "https://inavflight.github.io";
    license = licenses.gpl3;
    maintainers = with maintainers; [ elitak ];
    broken = true;
  };

}
