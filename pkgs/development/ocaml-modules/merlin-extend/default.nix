{ lib, buildDunePackage, fetchurl, cppo }:

buildDunePackage rec {
  pname = "merlin-extend";
  version = "0.6";

  useDune2 = true;

  src = fetchurl {
    url = "https://github.com/let-def/merlin-extend/releases/download/v${version}/merlin-extend-v${version}.tbz";
    sha256 = "0hvc4mz92x3rl2dxwrhvhzwl4gilnyvvwcqgr45vmdpyjyp3dwn2";
  };

  strictDeps = true;

  nativeBuildInputs = [ cppo ];

  meta = with lib; {
    homepage = "https://github.com/let-def/merlin-extend";
    description = "SDK to extend Merlin";
    license = licenses.mit;
    maintainers = [ ];
  };
}
