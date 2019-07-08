{ lib, buildPythonPackage, fetchPypi, tinycss2, pytest, pytestrunner }:

buildPythonPackage rec {
  pname = "cssselect2";
  version = "0.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "505d2ce3d3a1d390ddb52f7d0864b7efeb115a5b852a91861b498b92424503ab";
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
