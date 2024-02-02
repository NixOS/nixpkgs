{ lib
, buildPythonPackage
, fetchPypi
, importlib-metadata
, logilab-common
, pip
, six
, pytestCheckHook
, setuptools
}:

buildPythonPackage rec {
  pname = "logilab-constraint";
  version = "0.8.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-yIO8sL0sdSKw0OApj2SJsuaojYpwQRTK/hGOIX2+Wh8=";
  };

  nativeBuildInputs = [
    importlib-metadata
    pip
  ];

  propagatedBuildInputs = [
    logilab-common
    setuptools
    six
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  preCheck = ''
    # avoid ModuleNotFoundError: No module named 'logilab.common' due to namespace
    rm -r logilab
  '';

  disabledTests = [
    # these tests are abstract test classes intended to be inherited
    "Abstract"
  ];

  pythonImportsCheck = [ "logilab.constraint" ];

  meta = with lib; {
    description = "logilab-database provides some classes to make unified access to different";
    homepage = "https://forge.extranet.logilab.fr/open-source/logilab-constraint";
    changelog = "https://forge.extranet.logilab.fr/open-source/logilab-constraint/-/blob/${version}/CHANGELOG.md";
    license = licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ ];
  };
}

