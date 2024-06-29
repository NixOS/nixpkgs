{ lib
, fetchzip
, stdenv
}:

let
  _src = variant: suffix: hash: fetchzip ({
    name = variant;
    url = "https://github.com/ful1e5/apple_cursor/releases/download/v${version}/${variant}.${suffix}";
    hash = hash;
  } // (lib.optionalAttrs (suffix == "zip") { stripRoot = false; }));

  version = "2.0.0";
  srcs = [
    (_src "macOS-BigSur-White" "tar.gz" "sha256-3Ax2hMfkEL4cyJtGQpK3PqC/L5wtmgO0LsY4gkTQ2Bg=")
    (_src "macOS-BigSur-White-Windows" "zip" "sha256-V6J2Ddgq46BkgxCWVReZrvE7CsOczzV7slOpilKFG9E=")
    (_src "macOS-BigSur" "tar.gz" "sha256-VZWFf1AHum2xDJPMZrBmcyVrrmYGKwCdXOPATw7myOA=")
    (_src "macOS-BigSur-Windows" "zip" "sha256-lp28ACsK8BXe6rSDELL4GdXb1QEdOVC8Y6eLofctkR4=")
    (_src "macOS-Monterey-White" "tar.gz" "sha256-IfFYUbDW6mBe209iU1sBhFzolZd6YDVdJf+DPe9AQDM=")
    (_src "macOS-Monterey-White-Windows" "zip" "sha256-gUuBFOi0nDBoX9TWPg4eQhCAhwYeEhfDEbYpc+XsQNE=")
    (_src "macOS-Monterey" "tar.gz" "sha256-MHmaZs56Q1NbjkecvfcG1zAW85BCZDn5kXmxqVzPc7M=")
    (_src "macOS-Monterey-Windows" "zip" "sha256-ajxEgq7besaRajLn0gTPpp4euOWVqbzc78u720PWlyE=")
  ];
in stdenv.mkDerivation rec {
  pname = "apple_cursor";
  inherit version;
  inherit srcs;

  sourceRoot = ".";

  installPhase = ''
    install -dm 0755 $out/share/icons
    cp -r macOS* $out/share/icons/
  '';

  meta = with lib; {
    description = "Opensource macOS Cursors";
    homepage = "https://github.com/ful1e5/apple_cursor";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ colemickens ];
  };
}
