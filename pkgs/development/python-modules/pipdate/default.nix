{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, isPy27
, appdirs
, importlib-metadata
, requests
, pytest
}:

buildPythonPackage rec {
  pname = "pipdate";
  version = "0.5.1";
  disabled = isPy27; # abandoned

  src = fetchPypi {
    inherit pname version;
    sha256 = "d10bd408e4b067a2a699badf87629a12838fa42ec74dc6140e64a09eb0dc28cf";
  };

  propagatedBuildInputs = [
    appdirs
    requests
  ] ++ lib.optionals (pythonOlder "3.8") [
    importlib-metadata
  ];

  # can be removed when https://github.com/nschloe/pipdate/pull/41 gets merged
  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "importlib_metadata" "importlib_metadata; python_version < \"3.8\""
  '';

  checkInputs = [
    pytest
  ];

  checkPhase = ''
    HOME=$(mktemp -d) pytest test/test_pipdate.py
  '';

  # tests require network access
  doCheck = false;

  meta = with lib; {
    description = "pip update helpers";
    homepage = "https://github.com/nschloe/pipdate";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
