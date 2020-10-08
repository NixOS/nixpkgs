{ stdenv, buildPythonPackage, fetchPypi, isPy27, colorama, pytestCheckHook }:

buildPythonPackage rec {
  pname = "loguru";
  version = "0.5.3";

  disabled = isPy27;
  src = fetchPypi {
    inherit pname version;
    sha256 = "b28e72ac7a98be3d28ad28570299a393dfcd32e5e3f6a353dec94675767b6319";
  };

  checkInputs = [ pytestCheckHook colorama ];

  pytestFlagsArray = stdenv.lib.optionals stdenv.isDarwin [ "--ignore=tests/test_multiprocessing.py" ];

  disabledTests = [ "test_time_rotation_reopening" "test_file_buffering" ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ "test_rotation_and_retention" "test_rotation_and_retention_timed_file" "test_renaming" "test_await_complete_inheritance" ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/Delgan/loguru";
    description = "Python logging made (stupidly) simple";
    license = licenses.mit;
    maintainers = with maintainers; [ jakewaksbaum ];
  };
}
