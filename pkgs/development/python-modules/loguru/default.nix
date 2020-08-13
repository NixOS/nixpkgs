{ stdenv, buildPythonPackage, fetchPypi, isPy27, colorama, pytestCheckHook }:

buildPythonPackage rec {
  pname = "loguru";
  version = "0.5.1";
  
  disabled = isPy27;
  src = fetchPypi {
    inherit pname version;
    sha256 = "70201d5fce26da89b7a5f168caa2bb674e06b969829f56737db1d6472e53e7c3";
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
