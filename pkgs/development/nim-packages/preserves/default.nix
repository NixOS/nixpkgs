{ lib, stdenv, buildNimPackage, fetchFromGitea, nim-unwrapped, npeg }:

buildNimPackage rec {
  pname = "preserves";
  version = "20230530";
  src = fetchFromGitea {
    domain = "git.syndicate-lang.org";
    owner = "ehmry";
    repo = "${pname}-nim";
    rev = version;
    hash = "sha256-IRIBGjv4po8VyL873v++ovqz8Vg6a9Qbh/M1fxpQXvY=";
  };
  propagatedBuildInputs = [ npeg ];
  nimFlags = [ "--path:${nim-unwrapped}/nim" ];
  doCheck = !stdenv.isDarwin;
  meta = src.meta // {
    description = "Nim implementation of the Preserves data language";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ ehmry ];
  };
}
