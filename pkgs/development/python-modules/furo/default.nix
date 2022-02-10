{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, sphinx
, beautifulsoup4
}:

buildPythonPackage rec {
  pname = "furo";
  version = "2022.1.2";
  format = "flit";
  disable = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b217f218cbcd423ffbfe69baa79389d4ecebf2d86f0d593c44ef31da7b5aed30";
  };

  propagatedBuildInputs = [
    sphinx
    beautifulsoup4
  ];

  pythonImportsCheck = [ "furo" ];

  meta = with lib; {
    description = "A clean customizable documentation theme for Sphinx";
    homepage = "https://github.com/pradyunsg/furo";
    license = licenses.mit;
    maintainers = with maintainers; [ Luflosi ];
  };
}
