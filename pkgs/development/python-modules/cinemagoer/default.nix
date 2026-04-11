{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  lxml,
  sqlalchemy,
  python,
}:

buildPythonPackage {
  pname = "cinemagoer";
  version = "2025.12.31";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cinemagoer";
    repo = "cinemagoer";
    rev = "aca62692b6f0ca7ed9c70871bafd8b558c6ba6ec"; # No tag
    hash = "sha256-Aelgi+Wz2rxLBkJ3YoHJMfno0QoEKESIpwwrJUzAAF0=";
  };

  pythonRelaxDeps = [
    "lxml"
  ];

  build-system = [ setuptools ];

  dependencies = [
    lxml
    sqlalchemy
  ];

  preBuild = ''
    ${python.interpreter} rebuildmo.py
  '';

  # Tests require networking, and https://github.com/cinemagoer/cinemagoer/issues/240
  doCheck = false;

  pythonImportsCheck = [ "imdb" ]; # Former "imdbpy", upstream is yet to rename here

  meta = {
    description = "Python package for retrieving and managing the data of the IMDb movie database about movies and people";
    downloadPage = "https://github.com/cinemagoer/cinemagoer/";
    homepage = "https://cinemagoer.github.io/";
    license = lib.licenses.gpl2Only;
    maintainers = [ ];
  };
}
