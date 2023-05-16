{ lib
, callPackage
, buildPythonPackage
, fetchFromGitHub
, mkdocs
, csscompressor
, htmlmin
, jsmin
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "mkdocs-minify";
<<<<<<< HEAD
  version = "0.7.1";
=======
  version = "0.6.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "byrnereese";
    repo = "${pname}-plugin";
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-LDCAWKVbFsa6Y/tmY2Zne4nOtxe4KvNplZuWxg4e4L8=";
=======
    hash = "sha256-ajXkEKLBC86Y8YzDCZXd6x6QtLLrCDJkb6kDrRE536o=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    csscompressor
    htmlmin
    jsmin
    mkdocs
  ];

  nativeCheckInputs = [
    mkdocs
    pytestCheckHook
  ];

  pythonImportsCheck = [ "mkdocs" ];

  meta = with lib; {
    description = "A mkdocs plugin to minify the HTML of a page before it is written to disk.";
    homepage = "https://github.com/byrnereese/mkdocs-minify-plugin";
    license = licenses.mit;
    maintainers = with maintainers; [ tfc ];
  };
}
