{ lib, buildNimPackage, fetchFromSourcehut, pkg-config, tkrzw }:

buildNimPackage rec {
  pname = "tkrzw";
  version = "20220922";
  src = fetchFromSourcehut {
    owner = "~ehmry";
    repo = "nim-${pname}";
    rev = version;
    hash = "sha256-66rUuK+wUrqs1QYjteZcaIrfg+LHQNcR+XM+EtVuGsA=";
  };
  propagatedNativeBuildInputs = [ pkg-config ];
  propagatedBuildInputs = [ tkrzw ];
  doCheck = true;
  meta = with lib;
    src.meta // {
      description = "Nim wrappers over some of the Tkrzw C++ library";
      license = lib.licenses.apsl20;
      maintainers = with lib.maintainers; [ ehmry ];
    };
}
