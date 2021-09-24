{ buildPythonPackage
, fetchPypi
, lib
, mypy
, toml
, zope_interface
, zope_schema
}:

buildPythonPackage rec {
  pname = "mypy-zope";
  version = "0.3.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8eea53a0ecce8bce433527d1cccb4e2e32da07b730f4730c6a503ebddf297520";
  };

  postPatch = ''
    substituteInPlace setup.cfg --replace "mypy==0.910" "mypy"
  '';

  propagatedBuildInputs = [
    zope_interface
    zope_schema
    mypy
    toml
  ];

  pythonImportsCheck = [ "mypy_zope" ];

  meta = with lib; {
    description = "Plugin for mypy to support zope interfaces";
    homepage = "https://github.com/Shoobx/mypy-zope";
    license = licenses.mit;
    maintainers = with maintainers; [ superherointj ];
  };
}
