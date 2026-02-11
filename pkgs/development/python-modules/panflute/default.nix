{
  lib,
  fetchPypi,
  click,
  pyyaml,
  buildPythonPackage,
}:

buildPythonPackage rec {
  pname = "panflute";
  version = "2.3.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-XxvQKjTvOYLuAl7FtY+zpu7fwx2ZS4rjnY3JkVotjx8=";
  };

  propagatedBuildInputs = [
    click
    pyyaml
  ];

  pythonImportsCheck = [ "panflute" ];

  meta = {
    description = "Pythonic alternative to John MacFarlane's pandocfilters, with extra helper functions";
    homepage = "https://scorreia.com/software/panflute";
    changelog = "https://github.com/sergiocorreia/panflute/releases/tag/${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ synthetica ];
  };
}
