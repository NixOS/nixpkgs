{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
  flask,
  flask-httpauth,
  pytz,
  six,
  pymongo,
}:

buildPythonPackage rec {
  pname = "medallion";
  version = "3.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "oasis-open";
    repo = "cti-taxii-server";
    rev = "refs/tags/v${version}";
    hash = "sha256-+fWifWi/XR6MSOLhWXn2CFpItVdkOpzQItlrZkjapAk=";
  };

  build-system = [ setuptools ];

  dependencies = [
    flask
    flask-httpauth
    pymongo
    pytz
    six
  ];

  pythonImportsCheck = [ "medallion" ];

  meta = with lib; {
    description = "Minimal implementation of a TAXII 2.1 Server in Python";
    homepage = "https://medallion.readthedocs.io/en/latest/";
    changelog = "https://github.com/oasis-open/cti-taxii-server/blob/v${version}/CHANGES.txt";
    license = licenses.bsd3;
    maintainers = with maintainers; [ PapayaJackal ];
  };
}
