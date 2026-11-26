{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  django,
  nix-update-script,
}:
buildPythonPackage (finalAttrs: {
  pname = "django-db-geventpool";
  version = "4.0.8";
  pyproject = true;

  src = fetchPypi {
    pname = "django_db_geventpool";
    inherit (finalAttrs) version;
    hash = "sha256-jqEA5IFRUnL3bHf03zuzQBzoOMl1SXgtDTD6+ZDQy/Q=";
  };

  build-system = [ hatchling ];

  dependencies = [ django ];

  pythonImportsCheck = [ "django_db_geventpool" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Django database backend with gevent-aware connection pooling";
    homepage = "https://github.com/jneight/django-db-geventpool";
    changelog = "https://github.com/jneight/django-db-geventpool/blob/master/CHANGES.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ mistyttm ];
  };
})
