{ lib
, buildPythonPackage
, fetchPypi
, libarchive
, pacman
, pkgconfig
, setuptools
}:

buildPythonPackage rec {
  pname = "pyalpm";
  version = "0.10.6";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-mebsc7jEa7EkZgE/Io+DHuDRjoq2ZLkaAcKjxA3gfH8=";
  };

  nativeBuildInputs = [
    pkgconfig
    setuptools
  ];

  buildInputs = [
    libarchive
    pacman
  ];

  pythonImportsCheck = [ "pyalpm" "pycman" ];

  meta = with lib; {
    description = "Libalpm bindings for Python 3";
    homepage = "https://gitlab.archlinux.org/archlinux/pyalpm/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ samlukeyes123 ];
  };
}
