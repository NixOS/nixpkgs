{
  lib,
  fetchPypi,
  buildPythonPackage,
  lxml,
  pycryptodome,
  colorama,
}:

buildPythonPackage rec {
  pname = "libkeepass";
  version = "0.3.1.post1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-US2zOqHwE/zGeQqz2uuAVIehC0TkmV9xUFEy3JM9j18=";
  };

  propagatedBuildInputs = [
    lxml
    pycryptodome
    colorama
  ];

  # No tests on PyPI
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/libkeepass/libkeepass";
    description = "Library to access KeePass 1.x/KeePassX (v3) and KeePass 2.x (v4) files";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ jqueiroz ];
  };
}
