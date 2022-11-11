{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, flask
, events
, pymongo
, simplejson
, cerberus
, setuptools
}:

buildPythonPackage rec {
  pname = "eve";
  version = "2.0.3";
  format = "setuptools";

  src = fetchPypi {
    inherit version;
    pname = "Eve";
    sha256 = "sha256-UiOhnJyEy5bPIIRHAhuWo8AqHOCp0OE5d0btujfeq4o=";
  };

  disabled = pythonOlder "3.7";

  propagatedBuildInputs = [
    cerberus
    events
    flask
    pymongo
    simplejson
    setuptools
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "flask<2.2" "flask" \
      --replace "events>=0.3,<0.4" "events>=0.3"
  '';

  pythonImportsCheck = [ "eve" ];

  # tests call a running mongodb instance
  doCheck = false;

  meta = with lib; {
    homepage = "https://python-eve.org/";
    description = "Open source Python REST API framework designed for human beings";
    changelog = "https://github.com/pyeve/eve/blob/v${version}/CHANGES.rst";
    license = licenses.bsd3;
    maintainers = [ maintainers.marsam ];
  };
}
