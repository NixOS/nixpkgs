{ lib
, fetchPypi
, buildPythonPackage
, numpy
, scipy
, tables
}:

buildPythonPackage rec {
  pname = "deepdish";
  version = "0.3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1wqzwh3y0mjdyba5kfbvlamn561d3afz50zi712c7klkysz3mzva";
  };

  propagatedBuildInputs = [
    numpy
    scipy
    tables
  ];

  pythonImportsCheck = [
    "deepdish"
  ];

  # nativeCheckInputs = [
  #   pandas
  # ];

  # The tests are broken: `ModuleNotFoundError: No module named 'deepdish.six.conf'`
  doCheck = false;

  meta = with lib; {
    description = "Flexible HDF5 saving/loading and other data science tools from the University of Chicago.";
    homepage = "https://github.com/uchicago-cs/deepdish";
    license = licenses.asl20;
    maintainers = with maintainers; [ ndl ];
  };
}
