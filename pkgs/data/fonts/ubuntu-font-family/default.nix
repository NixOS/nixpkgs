{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation rec {
  pname = "ubuntu-font-family";
  version = "0.83";

  src = fetchzip {
    url = "https://assets.ubuntu.com/v1/fad7939b-ubuntu-font-family-${version}.zip";
    hash = "sha256-FAg1xn8Gcbwmuvqtg9SquSet4oTT9nqE+Izeq7ZMVcA=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/ubuntu
    mv *.ttf $out/share/fonts/ubuntu

    runHook postInstall
  '';

  meta = with lib; {
    description = "Ubuntu Font Family";
    longDescription = "The Ubuntu typeface has been specially
    created to complement the Ubuntu tone of voice. It has a
    contemporary style and contains characteristics unique to
    the Ubuntu brand that convey a precise, reliable and free attitude.";
    homepage = "http://font.ubuntu.com/";
    license = licenses.ufl;
    platforms = platforms.all;
    maintainers = [ maintainers.antono ];
  };
}
