{ stdenv, buildPythonPackage, fetchPypi, isPy27, colorama, pytestCheckHook }:

buildPythonPackage rec {
  pname = "loguru";
  version = "0.5.0";
  
  disabled = isPy27;
  src = fetchPypi {
    inherit pname version;
    sha256 = "15mv7l03sq0y512szxklnchlrcabwf4sk74h7n32zqp5kgsny3hy";
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
