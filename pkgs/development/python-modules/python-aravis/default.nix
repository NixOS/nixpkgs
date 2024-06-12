{ lib
, fetchFromGitHub
, substituteAll
, aravis
, buildPythonPackage
, numpy
, pygobject3
}:

buildPythonPackage rec {
  pname = "python-aravis";
  version = "0.5";
  src = fetchFromGitHub {
    owner = "SintefManufacturing";
    repo = "python-aravis";
    rev = "5750250cedb9b96d7a0172c0da9c1811b6b817af";
    sha256 = "sha256-PQfi9ehGHJMFkMj9Wp0D9u2/iaqOz44B39/dpYJJPCs=";
  };
  propagatedBuildInputs = [
    numpy
    pygobject3

    aravis
  ];

  patches = [
    (substituteAll {
      aravisPath = aravis.lib;
      src = ./patch_to_add_aravis_envvar.diff;
    })
  ];

  preBuild = ''
    # Override make_deb.py so that it doesn't try to call git
    echo "import aravis" > make_deb.py
    echo "DEBVERSION=aravis.__version__" >> make_deb.py
  '';

  meta = with lib; {
    description = "Pythonic interface to the auto-generated aravis bindings";
    homepage = "https://github.com/SintefManufacturing/python-aravis";
    changelog = "https://github.com/SintefManufacturing/python-aravis";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ charlesbaynham ];
  };
}
