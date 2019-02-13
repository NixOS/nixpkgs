{ lib
, buildPythonPackage
, fetchPypi
, setuptools_scm
, pytest
}:

buildPythonPackage rec {
  pname = "pytest-repeat";
  version = "0.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "84aba2fcca5dc2f32ae626a01708f469f17b3384ec3d1f507698077f274909d6";
  };

  buildInputs = [ setuptools_scm pytest ];

  checkPhase = ''
    py.test
  '';

  meta = {
    description = "Pytest plugin for repeating tests";
    homepage = https://github.com/pytest-dev/pytest-repeat;
    maintainers = with lib.maintainers; [ costrouc ];
    license = lib.licenses.mpl20;
  };
}
