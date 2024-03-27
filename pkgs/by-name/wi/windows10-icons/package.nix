{ lib, stdenv, fetchFromGitHub }:
stdenv.mkDerivation (finalAttrs: {
  pname = "windows10-icons";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "B00merang-Artwork";
    repo = "Windows-10";
    rev = "${finalAttrs.version}";
    hash = "sha256-Yz6a7FcgPfzz4w8cKp8oq7/usIBUUZV7qhVmDewmzrI=";
  };

  installPhase = ''
    install -Dm644 $(find . -type f -maxdepth 1) -t $out/share/icons/windows10
    for dir in $(find . -type d -maxdepth 1)
      do install -d $dir $out/share/icons/windows10/$dir
    done
  '';

  meta = with lib; {
    description = "Windows 10 icon theme";
    homepage = "http://b00merang.weebly.com/windows-10.html";
    license = licenses.unfree;
    maintainers = with maintainers; [ mib ];
    platforms = platforms.linux;
  };
})
