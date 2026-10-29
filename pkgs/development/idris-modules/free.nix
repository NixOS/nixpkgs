{
  build-idris-package,
  fetchFromGitHub,
  lib,
}:
build-idris-package {
  pname = "free";
  version = "2017-07-03";

  ipkgName = "idris-free";

  src = fetchFromGitHub {
    owner = "idris-hackers";
    repo = "idris-free";
    rev = "919950fb6a9d97c139c2d102402fec094a99c397";
    hash = "sha256-R5e+2qg8CfmCE+AXeJbMzATz0vVhVGLVOG1KpoJTjdg=";
  };

  meta = {
    description = "Free Monads and useful constructions to work with them";
    homepage = "https://github.com/idris-hackers/idris-free";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.brainrape ];
  };
}
