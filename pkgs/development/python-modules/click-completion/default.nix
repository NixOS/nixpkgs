{
  lib,
  buildPythonPackage,
  fetchPypi,
  isPy27,

  # propagates
  click,
  jinja2,
  shellingham,
  six,
}:

buildPythonPackage rec {
  pname = "click-completion";
  version = "0.5.2";
  format = "setuptools";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "5bf816b81367e638a190b6e91b50779007d14301b3f9f3145d68e3cade7bce86";
  };

  propagatedBuildInputs = [
    click
    jinja2
    shellingham
    six
  ];

  pythonImportsCheck = [ "click_completion" ];

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "Add or enhance bash, fish, zsh and powershell completion in Click";
    homepage = "https://github.com/click-contrib/click-completion";
    license = licenses.mit;
    maintainers = with maintainers; [ mbode ];
  };
}
