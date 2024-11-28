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
  version = "2.7.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "lepture";
    repo = "python-livereload";
    rev = "refs/tags/${version}";
    sha256 = "sha256-1at/KMgDTj0TTnq5Vjgklkyha3QUF8bFeKxQSrvx1oE=";
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
