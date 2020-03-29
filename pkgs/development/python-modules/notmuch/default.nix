{ stdenv
, buildPythonPackage
, notmuch
, python
}:

buildPythonPackage {
  inherit (notmuch) pname version src;

  sourceRoot = notmuch.pythonSourceRoot;

  buildInputs = [ python notmuch ];

  postPatch = ''
    sed -i -e '/CDLL/s@"libnotmuch\.@"${notmuch}/lib/libnotmuch.@' \
      notmuch/globals.py
  '';

  meta = with stdenv.lib; {
    description = "A Python wrapper around notmuch";
    homepage = https://notmuchmail.org/;
    license = licenses.gpl3;
    maintainers = with maintainers; [ ];
  };

}
