{ lib
, buildPythonApplication
, fetchFromGitHub
, pythonOlder
, python3
, mkdocs
}:

with python3.pkgs;

buildPythonApplication rec {
  pname = "mkdocs-material";
  version = "7.2.8";
  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
      repo = pname;
      owner = "squidfunk";
      rev = version;
      sha256 = "18vwzaxbnqq9xaz2hf3nncmc1z4jbmzkh6c1x42pln8zw3c3qjjy";
    };

  propagatedBuildInputs = [
    jinja2
    mkdocs
    pygments
    markdown
    pymdown-extensions
    mkdocs-material-extensions
    jinja2
  ];

  checkBuildInputs = [ mkdocs-material-extensions ];

  # Project has no tests
  doCheck = false;


  meta = with lib; {
    description = "Technical documentation that just works ";
    homepage = "https://squidfunk.github.io/mkdocs-material/";
    license = licenses.mit;
    maintainers = with maintainers; [ lde ];
  };
}
