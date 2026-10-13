{
  lib,
  buildPythonPackage,
  fetchPypi,
  requests,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "casttube";
  version = "0.2.1";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    sha256 = "10pw2sjy648pvp42lbbdmkkx79bqlkq1xcbzp1frraj9g66azljl";
  };

  build-system = [ setuptools ];

  dependencies = [ requests ];

  # no tests
  doCheck = false;

  meta = {
    description = "Interact with the Youtube Chromecast api";
    homepage = "https://github.com/ur1katz/casttube";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fpletz ];
  };
})
