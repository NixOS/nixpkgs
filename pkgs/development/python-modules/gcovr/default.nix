{
  lib,
  buildPythonPackage,
  fetchPypi,
  colorlog,
  jinja2,
  lxml,
  pygments,
  pythonOlder,
  tomli,
}:

buildPythonPackage rec {
  pname = "gcovr";
  version = "7.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-4+lctWyojbvnQctdaaor5JTrL8KgnuT2UWRKZw7lrrM=";
  };

  propagatedBuildInputs = [
    colorlog
    jinja2
    lxml
    pygments
  ] ++ lib.optionals (pythonOlder "3.11") [ tomli ];

  # There are no unit tests in the pypi tarball. Most of the unit tests on the
  # github repository currently only work with gcc5, so we just disable them.
  # See also: https://github.com/gcovr/gcovr/issues/206
  doCheck = false;

  pythonImportsCheck = [
    "gcovr"
    "gcovr.configuration"
  ];

  meta = with lib; {
    description = "Python script for summarizing gcov data";
    mainProgram = "gcovr";
    homepage = "https://www.gcovr.com/";
    changelog = "https://github.com/gcovr/gcovr/blob/${version}/CHANGELOG.rst";
    license = licenses.bsd0;
    maintainers = with maintainers; [ sigmanificient ];
  };
}
