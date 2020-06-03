{ python, stdenv, buildPythonPackage, fetchPypi
, pandas, appdirs, progressbar33, requests, typechecks, mock}:

buildPythonPackage rec {
  version = "1.1.5";
  pname = "datacache";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b2ca31b2b9d3803a49645ab4f5b30fdd0820e833a81a6952b4ec3a68c8ee24a7";
  };

  propagatedBuildInputs = [ pandas appdirs progressbar33 requests typechecks mock ];

  pythonImportsCheck = [ "datacache" ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/openvax/datacache";
    description = "Helpers for transparently downloading datasets";
    license = licenses.asl20;
    maintainer = maintainers.moritzs;
  };
}
