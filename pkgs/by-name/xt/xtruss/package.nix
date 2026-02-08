{
  lib,
  stdenv,
  fetchurl,
  cmake,
  halibut,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xtruss";
  version = "20211025.c25bf48";

  src = fetchurl {
    url = "https://www.chiark.greenend.org.uk/~sgtatham/xtruss/xtruss-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-ikuKHtXEn2UVLE62l7qD9qc9ZUk6jiAqj5ru36vgdHk=";
  };

  nativeBuildInputs = [
    cmake
    halibut
  ];

  meta = {
    description = "Easy-to-use X protocol tracing program";
    homepage = "https://www.chiark.greenend.org.uk/~sgtatham/xtruss";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "xtruss";
  };
})
