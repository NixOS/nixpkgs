{ lib, pkgs, buildNimPackage, fetchFromGitHub }:

buildNimPackage (finalAttrs: {
  pname = "wcwidth";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "shoyu777";
    repo = "wcwidth-nim";
    rev = "v${finalAttrs.version}";
    hash = "sha256-VuLaocfWV4/96+xiNr1US6f8UFySfidrqq8zuTD1aRk=";
  };

  meta = finalAttrs.src.meta // (with lib; {
    description = "Implementation of wcwidth with Nim";
    homepage = "https://github.com/shoyu777/wcwidth-nim";
    license = licenses.mit;
    maintainers = [ maintainers.joachimschmidt557 ];
  });
})
