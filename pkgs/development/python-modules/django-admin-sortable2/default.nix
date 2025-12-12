{
  lib,
  buildNpmPackage,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  setuptools,
  django,
}:
let
  pname = "django-admin-sortable2";
  version = "2.3";

  src = fetchFromGitHub {
    owner = "jrief";
    repo = "django-admin-sortable2";
    tag = version;
    hash = "sha256-BhAhql4Ou+CyIo90eKDfm3GSD8DO6uT67/VgcPz13JQ=";
  };

  assets = buildNpmPackage {
    pname = "${pname}-assets";
    inherit version src;
    npmDepsHash = "sha256-zM2iSCrGX5sS7Ysmmo8nR+/V9pMOatN6DX/G+hGdFEU=";

    installPhase = ''
      runHook preInstall

      install -Dm644 adminsortable2/static/adminsortable2/js/*.js -t $out

      runHook postInstall
    '';
  };
in

buildPythonPackage rec {
  inherit pname version src;
  pyproject = true;

  disabled = pythonOlder "3.9";

  build-system = [ setuptools ];

  dependencies = [ django ];

  preBuild = ''
    install -Dm644 ${assets}/*.js -t adminsortable2/static/adminsortable2/js
  '';

  pythonImportsCheck = [ "adminsortable2" ];

  # Tests are very slow (end-to-end with playwright)
  doCheck = false;

  meta = {
    description = "Generic drag-and-drop ordering for objects in the Django admin interface";
    homepage = "https://github.com/jrief/django-admin-sortable2";
    changelog = "https://github.com/jrief/django-admin-sortable2/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sephi ];
  };
}
