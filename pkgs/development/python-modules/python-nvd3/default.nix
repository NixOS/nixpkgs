{ lib
, buildPythonPackage
, fetchPypi
, jinja2
, python-slugify
# Test inputs
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "python-nvd3";
  version = "0.15.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fbd75ff47e0ef255b4aa4f3a8b10dc8b4024aa5a9a7abed5b2406bd3cb817715";
  };

  propagatedBuildInputs = [
    jinja2
    python-slugify
  ];

  pythonImportsCheck = [ "nvd3" ];
  doCheck = false;  # no tests either in pypi or GitHub repo

  meta = with lib; {
    description = "Python NVD3 - Chart Library for d3.js";
    homepage = "https://python-nvd3.readthedocs.io/en/latest/";
    changelog = "https://github.com/areski/python-nvd3/blob/develop/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ drewrisinger ];
  };
}
