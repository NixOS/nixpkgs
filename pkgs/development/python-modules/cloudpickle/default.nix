{ lib, buildPythonPackage, fetchPypi, isPy27
, pytest
, mock
, psutil
, futures
}:

buildPythonPackage rec {
  pname = "cloudpickle";
  version = "1.2.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0nc87ylxq1xm00xphfj5crh42rhi9am4zaszzx9k44qf2kbh294j";
  };

  propagatedBuildInputs = lib.optionals isPy27 [ futures ];

  checkInputs = [ pytest mock psutil ];
  # Disable tests which use subprocesses, as they will not inherit
  # correct PYTHONPATH, thus will fail to load modules such as 'psutil'
  checkPhase = ''
    cd tests
    pytest -k 'not (Protocol \
      or process \
      or interactive \
      or file_handles \
      or locally_defined_function \
      or dynamic_module)'
  '';

  meta = with lib; {
    description = "Extended pickling support for Python objects";
    homepage = https://github.com/cloudpipe/cloudpickle;
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ jonringer ];
  };
}
