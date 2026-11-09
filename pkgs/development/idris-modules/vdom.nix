{
  build-idris-package,
  fetchFromGitHub,
  lib,
}:
build-idris-package {
  pname = "vdom";
  version = "0.6.0";

  ipkgName = "idris-vdom";

  src = fetchFromGitHub {
    owner = "brandondyck";
    repo = "idris-vdom";
    rev = "ff32c14feeac937f7418830a9a3463cd9582be8a";
    hash = "sha256-bk+hh+6h0Isc4lCmuyzj8+1j/Zld/WZKuRnW23BQNCo=";
  };

  meta = {
    description = "Virtual DOM in pure Idris";
    homepage = "https://github.com/brandondyck/idris-vdom";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.brainrape ];
  };
}
