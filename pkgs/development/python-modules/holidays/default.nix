{ lib
, buildPythonPackage
, fetchPypi
, convertdate
, dateutil
, hijri-converter
, korean-lunar-calendar
, six
, python
, flake8
}:

buildPythonPackage rec {
  pname = "holidays";
  version = "0.10.5.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0g4hqbb94cwxlcwsjzrzxzlann1ks2r4mgnfzqz74a2rg1nih5zd";
  };

  postPatch = ''
    # ignore too long line issues
    # https://github.com/dr-prodigy/python-holidays/issues/423
    substituteInPlace tests.py \
      --replace "flake8.get_style_guide(ignore=[" "flake8.get_style_guide(ignore=['E501', "
  '';


  propagatedBuildInputs = [
    convertdate
    dateutil
    hijri-converter
    korean-lunar-calendar
    six
  ];

  checkInputs = [
    flake8
  ];

  checkPhase = ''
    ${python.interpreter} -m unittest
  '';

  pythonImportsCheck = [ "holidays" ];

  meta = with lib; {
    homepage = "https://github.com/dr-prodigy/python-holidays";
    description = "Generate and work with holidays in Python";
    license = licenses.mit;
    maintainers = with maintainers; [ jluttine ];
  };
}
