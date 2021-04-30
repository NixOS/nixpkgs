{ lib, buildPythonPackage, fetchPypi, pillow, scipy }:

buildPythonPackage rec {
  pname = "colorz";
  version = "1.0.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ghd90lgplf051fs5n5bb42zffd3fqpgzkbv6bhjw7r8jqwgcky0";
  };

  propagatedBuildInputs = [ pillow scipy ];

  # No tests
  doCheck = false;
  pythonImportsCheck = [ "colorz" ];

  meta = with lib; {
    description = "Python color scheme generator";
    homepage = "https://github.com/metakirby5/colorz";
    license = licenses.mit;
    maintainers = with maintainers; [ mnacamura ];
    platforms = platforms.unix;
  };
}
