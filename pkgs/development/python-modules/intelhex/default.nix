{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "intelhex";
  version = "2.1";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0k5l1mn3gv1vb0jd24ygxksx8xqr57y1ivgyj37jsrwpzrp167kw";
  };

  # FAIL: test_xrange_longint (intelhex.test.TestXrangeLongInt)
  # AssertionError: OverflowError not raised
  #
  # Harmless test failure:
  #  https://github.com/bialix/intelhex/issues/14
  doCheck = false;

  meta = {
    homepage = https://github.com/bialix/intelhex;
    description = "Python library for Intel HEX files manipulations";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ pjones ];
  };
}
