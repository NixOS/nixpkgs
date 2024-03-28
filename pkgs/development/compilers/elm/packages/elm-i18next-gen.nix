{ lib, buildNpmPackage, fetchFromGitHub }:

buildNpmPackage rec {
  pname = "elm-i18next-gen";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "yonigibbs";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-RBBTJA3sEpI5nIqhifDZGldUnVvaGK2ZeYqgvccODQ0=";
  };

  npmDepsHash = "sha256-eXh73Wb5x/7DLJk5bcpn3EkCAj8of76DrRoCHNHdvxE=";

  dontNpmBuild = true;
  npmInstallFlags = "--omit=dev";

  meta = with lib; {
    description = "Code generation for elm-i18next";
    homepage = "https://github.com/yonigibbs/elm-i18next-gen";
    license = licenses.mit;
    maintainers = with maintainers; [ ilyakooo0 ];
  };
}

