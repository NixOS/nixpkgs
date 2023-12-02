{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, toml
}:

buildPythonPackage rec {
  pname = "confight";
  version = "1.3.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-iv3I3e5dGr12TTSm5W/i1qrRCrKkrP8ZCChlcrENcxw=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    toml
  ];

  pythonImportsCheck = [ "confight" ];

  doCheck = false;

  meta = with lib; {
    description = "Python context manager for managing pid files";
    homepage = "https://github.com/avature/confight";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ mkg20001 ];
  };
}
