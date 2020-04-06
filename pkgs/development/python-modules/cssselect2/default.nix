{ lib, buildPythonPackage, fetchPypi, tinycss2, pytest, pytestrunner }:

buildPythonPackage rec {
  pname = "cssselect2";
  version = "0.2.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0skymzb4ncrm2zdsy80f53vi0arf776lvbp51hzh4ayp1il5lj3h";
  };

  # We're not interested in code quality tests
  postPatch = ''
    substituteInPlace setup.py \
      --replace "pytest-cov" "" \
      --replace "pytest-flake8" "" \
      --replace "pytest-isort" ""
    substituteInPlace setup.cfg \
      --replace "--cov=cssselect2" "" \
      --replace "--flake8" "" \
      --replace "--isort" ""
  '';

  propagatedBuildInputs = [ tinycss2 ];

  checkInputs = [ pytest pytestrunner ];

  meta = with lib; {
    description = "CSS selectors for Python ElementTree";
    homepage = https://github.com/Kozea/cssselect2;
    license = licenses.bsd3;
  };
}
