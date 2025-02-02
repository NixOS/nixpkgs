{
  lib,
  buildPythonPackage,
  fetchPypi,
  psutil,
}:

buildPythonPackage rec {
  pname = "powerline-mem-segment";
  version = "2.4.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0507zw7g449zk7dcq56adcdp71inbqfdmp6y5yk4x4j7kkp6pii9";
  };

  propagatedBuildInputs = [ psutil ];

  pythonImportsCheck = [ "powerlinemem" ];

  meta = with lib; {
    description = "Segment for Powerline showing the current memory usage in percent or absolute values.";
    homepage = "https://github.com/mKaloer/powerline_mem_segment";
    license = licenses.asl20;
    maintainers = with maintainers; [ thomasjm ];
  };
}
