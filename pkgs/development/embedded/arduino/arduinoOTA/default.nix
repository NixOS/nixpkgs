{ lib
, buildGoModule
, fetchFromGitHub
, nix-update-script
}:
buildGoModule rec {
  pname = "arduinoOTA";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "arduino";
    repo = pname;
    rev = version;
    hash = "sha256-HaNMkeV/PDEotYp8+rUKFaBxGbZO8qA99Yp2sa6glz8=";
  };

  vendorHash = null;

  postPatch = ''
    substituteInPlace version/version.go \
      --replace 'versionString        = ""' 'versionString        = "${version}"'
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    homepage = "https://github.com/arduino/arduinoOTA";
    description = "A tool for uploading programs to Arduino boards over a network";
    mainProgram = "arduinoOTA";
    license = licenses.gpl3;
    maintainers = with maintainers; [ poelzi ];
    platforms = platforms.all;
  };
}
