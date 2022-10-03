{ lib, stdenv, fetchzip }:

stdenv.mkDerivation rec {
  pname = "ubuntu-font-family";
  version = "0.83";

  src = fetchzip {
    url = "https://assets.ubuntu.com/v1/fad7939b-${pname}-${version}.zip";
    hash = "sha256-FAg1xn8Gcbwmuvqtg9SquSet4oTT9nqE+Izeq7ZMVcA=";
  };

  installPhase = ''
    install -D -m 644 -t "$out/share/fonts/truetype" *.ttf
  '';

  outputHashMode = "recursive";
  outputHash = "sha256-EEcYtOeOd2DKyRLo1kG7lk8euaFilCFMXMJNAosxHiQ=";

  meta = with lib; {
    description = "Ubuntu Font Family";
    longDescription = "The Ubuntu typeface has been specially
    created to complement the Ubuntu tone of voice. It has a
    contemporary style and contains characteristics unique to
    the Ubuntu brand that convey a precise, reliable and free attitude.";
    homepage = "http://font.ubuntu.com/";
    license = licenses.free;
    platforms = platforms.all;
    maintainers = with maintainers; [ antono ];
  };
}
