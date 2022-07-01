{ lib
, buildPythonPackage
, flit-core
, pythonOlder
, fetchPypi
, tinycss2
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "cssselect2";
  version = "0.5.0";
  format = "pyproject";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-2Yp7vdjrxGCTJ5GV1mmjNZvVoj+QwZ6CwZ2e7vMz5hc=";
  };

  postPatch = ''
    sed -i '/^addopts/d' pyproject.toml
  '';

  nativeBuildInputs = [
    flit-core
  ];

  propagatedBuildInputs = [ tinycss2 ];

  checkInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "cssselect2" ];

  meta = with lib; {
    description = "CSS selectors for Python ElementTree";
    homepage = "https://github.com/Kozea/cssselect2";
    license = licenses.bsd3;
  };
}
