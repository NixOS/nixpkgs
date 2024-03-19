{
  lib, fetchFromGitHub, buildDunePackage
, zarith_stubs_js ? null
}:

buildDunePackage rec {
  pname = "integers_stubs_js";
  version = "1.0";

  minimalOCamlVersion = "4.08";
  duneVersion = "3";

  src = fetchFromGitHub {
    owner = "o1-labs";
    repo = pname;
    rev = version;
    sha256 = "sha256-lg5cX9/LQlVmR42XcI17b6KaatnFO2L9A9ZXfID8mTY=";
  };

  propagatedBuildInputs = [ zarith_stubs_js ];
  doCheck = true;

  meta = {
    description = "Javascript stubs for the integers library in js_of_ocaml";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bezmuth ];
    inherit (src.meta) homepage;
  };
}
