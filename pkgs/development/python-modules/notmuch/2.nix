{ stdenv
, buildPythonPackage
, notmuch
, python
, cffi
}:

buildPythonPackage {
  pname = "notmuch2";
  inherit (notmuch) version src;

  sourceRoot = "${notmuch.src.name}/bindings/python-cffi";

  buildInputs = [ python notmuch cffi ];

  meta = with stdenv.lib; {
    description = "Pythonic bindings for the notmuch mail database using CFFI";
    homepage = "https://notmuchmail.org/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ teto ];
  };
}
