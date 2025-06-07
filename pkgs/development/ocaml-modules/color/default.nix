{
  lib,
  fetchFromGitHub,
  buildDunePackage,
  gg,
}:

buildDunePackage rec {
  pname = "color";
  version = "0.3.0";

  minimalOCamlVersion = "4.08";

  src = fetchFromGitHub {
    owner = "anuragsoni";
    repo = "color";
    tag = version;
    hash = "sha256-MuCzQsTOz31iQVrwg6WosWjj15730X6D1q6+eeApcmQ=";
  };

  propagatedBuildInputs = [
    gg
  ];

  meta = {
    description = "Converts between different color formats";
    longDescription = ''
      Library that converts between different color formats. Right now it deals with RGB[A], HSL[A], OkLab, and Oklch formats. All those format convert to and from [Gg.Color.t]
    '';
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fgaz ];
    homepage = "https://github.com/anuragsoni/color";
    changelog = "https://github.com/anuragsoni/color/blob/${version}/CHANGES.md";
  };
}
