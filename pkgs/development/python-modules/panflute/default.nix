{
  lib,
  fetchPypi,
  click,
  pyyaml,
  buildPythonPackage,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "panflute";
  version = "2.3.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-XxvQKjTvOYLuAl7FtY+zpu7fwx2ZS4rjnY3JkVotjx8=";
  };

  propagatedBuildInputs = [
    click
    pyyaml
  ];

  pythonImportsCheck = [ "panflute" ];

  meta = with lib; {
    description = "Pythonic alternative to John MacFarlane's pandocfilters, with extra helper functions";
    homepage = "https://scorreia.com/software/panflute";
    changelog = "https://github.com/sergiocorreia/panflute/releases/tag/${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ synthetica ];
  };
}
