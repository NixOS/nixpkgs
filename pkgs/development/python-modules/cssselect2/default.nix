{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, tinycss2
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "cssselect2";
  version = "0.4.1";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "93fbb9af860e95dd40bf18c3b2b6ed99189a07c0f29ba76f9c5be71344664ec8";
  };

  postPatch = ''
    sed -i '/^addopts/d' pyproject.toml
  '';

  propagatedBuildInputs = [ tinycss2 ];

  checkInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "cssselect2" ];

  meta = with lib; {
    description = "CSS selectors for Python ElementTree";
    homepage = "https://github.com/Kozea/cssselect2";
    license = licenses.bsd3;
  };
}
