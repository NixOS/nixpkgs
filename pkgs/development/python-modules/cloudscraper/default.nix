{
  lib,
  buildPythonPackage,
  fetchPypi,
  requests,
  requests-toolbelt,
  pyparsing,
}:

buildPythonPackage rec {
  pname = "cloudscraper";
  version = "1.2.71";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-QpxuiqaRbVutXIperFDz6lPJrCJhb2yyGxjcxxUX0NM=";
  };

  propagatedBuildInputs = [
    requests
    requests-toolbelt
    pyparsing
  ];

  # The tests require several other dependencies, some of which aren't in
  # nixpkgs yet, and also aren't included in the PyPI bundle.  TODO.
  doCheck = false;

  pythonImportsCheck = [ "cloudscraper" ];

  meta = {
    description = "Python module to bypass Cloudflare's anti-bot page";
    homepage = "https://github.com/venomous/cloudscraper";
    changelog = "https://github.com/VeNoMouS/cloudscraper/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kini ];
  };
}
