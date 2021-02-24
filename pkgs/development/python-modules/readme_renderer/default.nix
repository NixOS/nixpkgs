{ lib
, bleach
, buildPythonPackage
, cmarkgfm
, docutils
, fetchPypi
, future
, mock
, pygments
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "readme_renderer";
  version = "29.0";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-kv1awr+Gd/MQ8zA6pLzludX58glKuYwp8TeR17gFo9s=";
  };

  propagatedBuildInputs = [
    bleach
    cmarkgfm
    docutils
    future
    pygments
  ];

  checkInputs = [
    mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "readme_renderer" ];

  meta = with lib; {
    description = "Python library for rendering readme descriptions";
    homepage = "https://github.com/pypa/readme_renderer";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
