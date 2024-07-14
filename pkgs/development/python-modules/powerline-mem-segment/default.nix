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
    hash = "sha256-KcZr7pxHkk6mL97c2hxeNoZzG2vKFMzamT8R8g7/BxQ=";
  };

  propagatedBuildInputs = [ psutil ];

  pythonImportsCheck = [ "powerlinemem" ];

  meta = with lib; {
    description = "Segment for Powerline showing the current memory usage in percent or absolute values";
    homepage = "https://github.com/mKaloer/powerline_mem_segment";
    license = licenses.asl20;
    maintainers = with maintainers; [ thomasjm ];
  };
}
