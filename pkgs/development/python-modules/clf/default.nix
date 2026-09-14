{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  docopt,
  requests,
  pygments,
}:

buildPythonPackage (finalAttrs: {
  pname = "clf";
  version = "0.5.7";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-q8kZoemWZ/Mv3eFd+0vFJ9viLPhqF6y3ikSdfy3+k34=";
  };

  build-system = [ setuptools ];

  patchPhase = ''
    sed -i 's/==/>=/' requirements.txt
  '';

  dependencies = [
    docopt
    requests
    pygments
  ];

  # Error when running tests:
  # No local packages or download links found for requests
  doCheck = false;

  pythonImportsCheck = [ "clf" ];

  meta = {
    homepage = "https://github.com/ncrocfer/clf";
    description = "Command line tool to search snippets on Commandlinefu.com";
    mainProgram = "clf";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ koral ];
  };
})
