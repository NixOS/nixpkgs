{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, sphinx
, beautifulsoup4
}:

buildPythonPackage rec {
  pname = "furo";
  version = "2021.8.11b42";
  format = "flit";
  disable = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-rhi2T57EfidQV1IHBkplCbzLlBCC5gVGmbkCf40s0qU=";
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
