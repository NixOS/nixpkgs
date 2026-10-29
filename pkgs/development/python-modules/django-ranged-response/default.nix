{
  lib,
  fetchPypi,
  buildPythonPackage,
  setuptools,
  django,
}:

buildPythonPackage (finalAttrs: {
  pname = "django-ranged-response";
  version = "0.2.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-9x//NSo3MWub6tcX/Hbk3dbJuZxGgM30eDuXVa8c+YU=";
  };

  build-system = [ setuptools ];

  # tests not included in PyPi package, github source is not up to date with 0.2.0
  doCheck = false;

  dependencies = [ django ];

  pythonImportsCheck = [ "ranged_response" ];

  meta = {
    description = "Modified FileResponse that returns `Content-Range` headers with the HTTP response, so browsers (read Safari 9+) that request the file, can stream the response properly";
    homepage = "https://github.com/wearespindle/django-ranged-fileresponse";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mrmebelman ];
  };
})
