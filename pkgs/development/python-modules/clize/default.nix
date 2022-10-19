{ lib
, buildPythonPackage
, fetchPypi

# build
, setuptools

# propagtes
, sigtools
, six
, attrs
, od
, docutils

# extras: datetime
, python-dateutil

# tests
, pygments
, unittest2
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "clize";
  version = "5.0.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-/cFpEvAN/Movd38xaE53Y+D9EYg/SFyHeqtlVUo1D0I=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "docutils ~= 0.17.0" "docutils" \
      --replace "attrs>=19.1.0,<22" "attrs>=19.1.0"
  '';

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    attrs
    docutils
    od
    sigtools
    six
  ];

  passthru.optional-dependencies = {
    datetime = [
      python-dateutil
    ];
  };

  # repeated_test no longer exists in nixpkgs
  # also see: https://github.com/epsy/clize/issues/74
  doCheck = false;
  checkInputs = [
    pytestCheckHook
    python-dateutil
    pygments
    unittest2
  ];

  pythonImportsCheck = [ "clize" ];

  meta = with lib; {
    description = "Command-line argument parsing for Python";
    homepage = "https://github.com/epsy/clize";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
