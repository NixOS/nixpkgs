{
  lib,
  fetchFromGitHub,
  buildDunePackage,
  cppo,
}:

buildDunePackage rec {
  pname = "ocolor";
  version = "1.3.1";

  minimalOCamlVersion = "4.02";

  src = fetchFromGitHub {
    owner = "marc-chevalier";
    repo = pname;
    rev = "refs/tags/${version}";
    sha256 = "osQTZGJp9yDoKNa6WoyhViNbRg1ukcD0Jxiu4VxqeUc=";
  };

  nativeBuildInputs = [
    cppo
  ];

  meta = {
    description = "Print with style in your terminal using Format’s semantic tags";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ toastal ];
    homepage = "https://github.com/marc-chevalier/ocolor";
  };
}
