{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, emoji
, pydbus
, pygobject3
, strenum
, unidecode
}:

buildPythonPackage rec {
  pname = "mpris-server";
  version = "0.9.6";
  pyproject = true;

  src = fetchPypi {
    pname = "mpris_server";
    inherit version;
    hash = "sha256-T0ZeDQiYIAhKR8aw3iv3rtwzc+R0PTQuIh6+Hi4rIHQ=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    emoji
    pydbus
    pygobject3
    strenum
    unidecode
  ];

  # upstream has no tests
  doCheck = false;

  pythonImportsCheck = [ "mpris_server" ];

  meta = {
    description = "Integrate MPRIS Media Player support into your app";
    longDescription = ''
      mpris_server provides adapters to integrate MPRIS support in your
      media player or device. Whereas existing MPRIS libraries for Python
      implement clients for apps with existing MPRIS support, mpris_server
      is a library used to implement MPRIS support in apps that don't
      already have it.
    '';
    homepage = "https://github.com/alexdelorenzo/mpris_server";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ ];
  };
}
