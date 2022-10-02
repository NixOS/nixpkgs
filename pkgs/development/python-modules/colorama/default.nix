{ lib, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  pname = "colorama";
  version = "0.4.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-5sa0M0/FCYimOdm5iqQpoLV9puF7mkTwRR+TC2lnt6Q=";
  };

  # No tests in archive
  doCheck = false;

  pythonImportsCheck = [ "colorama" ];

  meta = with lib; {
    description = "Cross-platform colored terminal text";
    homepage = "https://github.com/tartley/colorama";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}

