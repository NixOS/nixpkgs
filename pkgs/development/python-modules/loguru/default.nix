{ stdenv, buildPythonPackage, fetchPypi, isPy27, colorama, pytestCheckHook }:

buildPythonPackage rec {
  pname = "loguru";
  version = "0.5.0";
  
  disabled = isPy27;
  src = fetchPypi {
    inherit pname version;
    sha256 = "1e0e6ff59be5e22f863d909ca989e34bb14c21b374f6af45281e603d003dbb96";
  };

  checkInputs = [ pytestCheckHook colorama ];

  disabledTests = [ "test_time_rotation_reopening" "test_file_buffering" ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ "test_rotation_and_retention" "test_rotation_and_retention_timed_file" "test_renaming" "test_await_complete_inheritance" ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/Delgan/loguru";
    description = "Python logging made (stupidly) simple";
    license = licenses.mit;
    maintainers = with maintainers; [ jakewaksbaum ];
  };
}
