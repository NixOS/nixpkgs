{
  lib,

  buildPythonPackage,
  notmuch,
  python,
}:

buildPythonPackage {
  inherit (notmuch) pname version src;

  sourceRoot = notmuch.pythonSourceRoot;

  format = "setuptools";

  buildInputs = [
    python
    notmuch
  ];

  postPatch = ''
    sed -i -e '/CDLL/s@"libnotmuch\.@"${notmuch}/lib/libnotmuch.@' \
      notmuch/globals.py
  '';

  # no tests
  doCheck = false;
  pythonImportsCheck = [ "notmuch" ];

  meta = {
    description = "Python wrapper around notmuch";
    homepage = "https://notmuchmail.org/";
    license = lib.licenses.gpl3;
    maintainers = [ ];
  };
}
