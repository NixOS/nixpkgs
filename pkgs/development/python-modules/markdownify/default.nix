{ buildPythonPackage
, beautifulsoup4
, six
, flake8
, pytestCheckHook
, lib
, fetchFromGitHub
}:

buildPythonPackage rec {
  name = "markdownify";
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "matthewwithanm";
    repo = "python-markdownify";
    rev = version;
    sha256 = "xT7LNyfzEbO4xLFbdVEL0soMrFvurTcxENetXODycYs=";
  };

  propagatedBuildInputs = [ beautifulsoup4 six ];

  nativeBuildInputs =  [ flake8 ];

  checkInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "markdownify" ];

  meta = with lib; {
    description = "Convert HTML to Markdown";
    homepage = "https://github.com/matthewwithanm/python-markdownify";
    license = licenses.mit;
    maintainers = with maintainers; [ milahu ];
  };
}
