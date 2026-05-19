{
  lib,
  fetchFromGitHub,
  buildDunePackage,
  re,
}:

buildDunePackage (finalAttrs: {
  pname = "ninja_utils";
  version = "1.0.0";

  minimalOCamlVersion = "4.12";

  src = fetchFromGitHub {
    owner = "CatalaLang";
    repo = "ninja_utils";
    tag = finalAttrs.version;
    hash = "sha256-2OYsZVk7/KYHXHTqAAEyVEHzcUCC+vBRU1s1XdfnWaE=";
  };

  propagatedBuildInputs = [ re ];

  meta = {
    description = "Small library used to generate Ninja build files";
    homepage = "https://github.com/CatalaLang/ninja_utils";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.stepbrobd ];
  };
})
