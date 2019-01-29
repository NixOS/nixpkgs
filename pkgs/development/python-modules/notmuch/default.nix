{ stdenv
, buildPythonPackage
, pkgs
, python
}:

buildPythonPackage rec {
  name = "python-${pkgs.notmuch.name}";

  src = pkgs.notmuch.src;

  sourceRoot = pkgs.notmuch.pythonSourceRoot;

  buildInputs = [ python pkgs.notmuch ];

  postPatch = ''
    sed -i -e '/CDLL/s@"libnotmuch\.@"${pkgs.notmuch}/lib/libnotmuch.@' \
      notmuch/globals.py
  '';

  meta = with stdenv.lib; {
    description = "A Python wrapper around notmuch";
    homepage = https://notmuchmail.org/;
    license = licenses.gpl3;
    maintainers = with maintainers; [ garbas ];
  };

}
