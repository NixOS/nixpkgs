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

  meta = with lib; {
    description = "A Python wrapper around notmuch";
    homepage = "https://notmuchmail.org/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ ];
  };
}
