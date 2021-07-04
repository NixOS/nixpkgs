{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "plasma-chili";
  version = "0.5.5";

  src = fetchFromGitHub {
    owner = "MarianArlt";
    repo = "kde-plasma-chili";
    rev = "${version}";
    sha256 = "17pkxpk4lfgm14yfwg6rw6zrkdpxilzv90s48s2hsicgl3vmyr3x";
  };

  installPhase = ''
    mkdir -p $out/share/sddm/themes/plasma-chili
    mv * $out/share/sddm/themes/plasma-chili/
  '';

  meta = with stdenv.lib; {
    license = licenses.gpl3;
    maintainers = with maintainers; [ illegalprime ];
    homepage = https://github.com/MarianArlt/sddm-chili;
    description = "The chili login theme for SDDM";
    longDescription = ''
      Chili is hot, just like a real chili!
      Spice up the login experience for your users, your family and yourself.
      Chili reduces all the clutter and leaves you with a clean,
      easy to use, login interface with a modern yet classy touch.
    '';
  };
}
