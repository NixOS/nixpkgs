{ lib, buildPythonPackage, fetchPypi, tinycss2, pytest, pytestrunner }:

buildPythonPackage rec {
  pname = "cssselect2";
  version = "0.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5c2716f06b5de93f701d5755a9666f2ee22cbcd8b4da8adddfc30095ffea3abc";
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
    homepage = "https://github.com/Kozea/cssselect2";
    license = licenses.bsd3;
  };
}
