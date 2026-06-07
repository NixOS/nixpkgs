{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  docopt,
  requests,
  pygments,
}:

buildPythonPackage rec {
  pname = "clf";
  version = "0.5.7";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "abc919a1e99667f32fdde15dfb4bc527dbe22cf86a17acb78a449d7f2dfe937e";
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

  meta = {
    homepage = "https://github.com/ncrocfer/clf";
    description = "Command line tool to search snippets on Commandlinefu.com";
    mainProgram = "clf";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ koral ];
  };
}
