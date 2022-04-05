{ lib
, stdenv
, fetchFromGitHub
, cmake
}:

# Used by opensubdiv and blender
let
  pname = "clew";
  version = "0.10";
in
stdenv.mkDerivation {
  inherit pname version;

  nativeBuildInputs = [ cmake ];

  src = fetchFromGitHub {
    owner = "martijnberger";
    repo = pname;
    rev = version;
    hash = "sha256-51HkWGHlvk0d7jayCqy+nInY7C/EUIex1+LO5FjL74c=";
  };

  meta = {
    maintainers = [ lib.maintainers.SomeoneSerge ];
    license = lib.licenses.boost;
    changelog = "https://github.com/martijnberger/clew/releases/tag/${version}";
    description = "The OpenCL Extension Wrangler Library";
    homepage = "https://github.com/martijnberger/clew";
    platforms = lib.platforms.linux; # upstream mentions windows and darwin support too
  };
}
