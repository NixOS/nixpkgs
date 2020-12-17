{ lib
, buildPythonPackage
, keystone
}:

buildPythonPackage rec {
  inherit (keystone) pname src version buildInputs nativeBuildInputs;

  dontUseCmakeConfigure = 1;
  preBuild = "cd bindings/python";

  meta = with lib; {
    inherit (keystone.meta) description license homepage;
    maintainers = [ maintainers.mic92 ];
  };
}
