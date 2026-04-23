{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonRelaxDepsHook,
  poetry-core,
  fonttools,
  openstep-plist,
  ufolib2,
  glyphslib,
  bump2version,
}:

buildPythonPackage rec {
  pname = "bumpfontversion";
  version = "0.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "simoncozens";
    repo = "bumpfontversion";
    tag = "v${version}";
    hash = "sha256-qcKZGv/KeeSRBq4SdnuZlurp0CUs40iEQjw9/1LltUg=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'poetry>=' 'poetry-core>=' \
      --replace-fail 'poetry.masonry.api' 'poetry.core.masonry.api'
  '';

  nativeBuildInputs = [ pythonRelaxDepsHook ];

  pythonRelaxDeps = [ "glyphslib" ];

  build-system = [ poetry-core ];

  dependencies = [
    fonttools
    openstep-plist
    ufolib2
    glyphslib
    bump2version
  ];

  meta = {
    description = "Version-bump your font sources";
    homepage = "https://github.com/simoncozens/bumpfontversion";
    license = lib.licenses.asl20;
    mainProgram = "bumpfontversion";
    maintainers = with lib.maintainers; [ jopejoe1 ];
  };
}
