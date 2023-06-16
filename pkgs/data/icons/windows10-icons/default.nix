{ lib, stdenv, fetchurl }:
stdenv.mkDerivation rec {
  pname = "windows10-icons";
  version = "1.0";

  src = fetchurl {
    url = "https://github.com/B00merang-Artwork/Windows-10/archive/refs/tags/${version}.tar.gz";
    sha256 = "sha256-ZGuLyOBNOANIicqs7zhGy2ZVmV8YBdh7P/e8Cykkmq4=";
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
}
