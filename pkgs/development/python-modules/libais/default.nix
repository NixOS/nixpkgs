{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  six,
}:

buildPythonPackage rec {
  pname = "libais";
  version = "0.17";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-6yrqIpjF6XaSfXSOTA0B4f3aLcHXkgA/3WBZBBNQ018=";
  };

  build-system = [ setuptools ];

  dependencies = [ six ];

  nativeCheckInputs = [ pytestCheckHook ];

  # data files missing
  doCheck = false;

  pythonImportsCheck = [ "ais" ];

  meta = with lib; {
    description = "Library for decoding maritime Automatic Identification System messages";
    homepage = "https://github.com/schwehr/libais";
    changelog = "https://github.com/schwehr/libais/blob/master/Changelog.md";
    license = licenses.asl20;
    maintainers = [ ];
    platforms = platforms.unix;
  };
}
