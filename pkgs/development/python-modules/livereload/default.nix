{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  django,
  pytestCheckHook,
  tornado,
  six,
}:

buildPythonPackage rec {
  pname = "livereload";
  version = "2.6.3";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "lepture";
    repo = "python-livereload";
    rev = version;
    sha256 = "1alp83h3l3771l915jqa1ylyllad7wxnmblayan0z0zj37jkp9n7";
  };

  buildInputs = [ django ];

  propagatedBuildInputs = [
    tornado
    six
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [ "test_watch_multiple_dirs" ];

  meta = {
    description = "Runs a local server that reloads as you develop";
    mainProgram = "livereload";
    homepage = "https://github.com/lepture/python-livereload";
    license = lib.licenses.bsd3;
    maintainers = with lib; [ ];
  };
}
