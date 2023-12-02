{ lib
, buildPythonPackage
, fetchPypi
, emoji
, pydbus
, pygobject3
, unidecode
, setuptools
}:
buildPythonPackage rec {
  pname = "mpris-server";
  version = "0.8.1";
  pyproject = true;

  src = fetchPypi {
    pname = "mpris_server";
    inherit version;
    hash = "sha256-dfnFX+u7PhQb4ScHIkRHnGVpCABZhhlw/R+ks63zcec=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    emoji
    pydbus
    pygobject3
    unidecode
  ];

  pythonImportsCheck = [ "mpris_server" ];

  # upstream has no tests
  doCheck = false;

  meta = with lib; {
    description = "Publish a MediaPlayer2 MPRIS device to D-Bus";
    homepage = "https://pypi.org/project/mpris-server/";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ quadradical ];
  };
}
