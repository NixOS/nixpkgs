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
    tag = version;
    sha256 = "osQTZGJp9yDoKNa6WoyhViNbRg1ukcD0Jxiu4VxqeUc=";
  };

  nativeBuildInputs = [
    cppo
  ];

  meta = with lib; {
    description = "Print with style in your terminal using Format’s semantic tags";
    license = licenses.mit;
    maintainers = with maintainers; [ toastal ];
    homepage = "https://github.com/marc-chevalier/ocolor";
  };
}
