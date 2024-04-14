{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, requests
, pytestCheckHook
, mock
, sphinx
}:

buildPythonPackage rec {
  pname = "readthedocs-sphinx-ext";
  version = "2.2.5";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-7l/VuZ258MGAsjlsvOUoqjZnGVG5UmuwJy2/zlUXvSc=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    requests
  ];

  nativeCheckInputs = [
    pytestCheckHook
    mock
    sphinx
  ];

  meta = with lib; {
    description = "Sphinx extension for Read the Docs overrides";
    homepage = "https://github.com/rtfd/readthedocs-sphinx-ext";
    license = licenses.mit;
  };
}
