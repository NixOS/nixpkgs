{ lib, buildPythonPackage, fetchPypi, future, configparser, isPy27 }:

buildPythonPackage rec {
  pname = "arabic_reshaper";
  version = "2.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "zzGPpdUdLSJPpJv2vbu0aE9r0sBot1z84OYH+JrBmdw=";
  };

  propagatedBuildInputs = [ future ]
    ++ lib.optionals isPy27 [ configparser ];

  # Tests are not published on pypi
  doCheck = false;

  pythonImportsCheck = [ "arabic_reshaper" ];

  meta = with lib; {
    homepage = "https://github.com/mpcabd/python-arabic-reshaper";
    description = "Reconstruct Arabic sentences to be used in applications that don't support Arabic";
    platforms = platforms.unix;
    maintainers = with maintainers; [ freezeboy ];
  };
}
