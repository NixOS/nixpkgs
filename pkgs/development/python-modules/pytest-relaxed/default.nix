{ lib
, buildPythonPackage
, fetchPypi
, pytest
, six
, decorator
, pytestCheckHook
}:

buildPythonPackage rec {
  version = "1.1.5";
  pname = "pytest-relaxed";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e39a7e5b14e14dfff0de0ad720dfffa740c128d599ab14cfac13f4deb34164a6";
  };

  # newer decorator versions are incompatible and cause the test suite to fail
  # but only a few utility functions are used from this package which means it has no actual impact on test execution in paramiko and Fabric
  postPatch = ''
    substituteInPlace setup.py \
      --replace "decorator>=4,<5" "decorator>=4" \
      --replace "pytest>=3,<5" "pytest>=3"
  '';

  buildInputs = [ pytest ];

  propagatedBuildInputs = [ six decorator ];

  checkInputs = [ pytestCheckHook ];

  # lots of assertion errors mainly around decorator
  doCheck = false;

  meta = with lib; {
    homepage = "https://pytest-relaxed.readthedocs.io/";
    description = "Relaxed test discovery/organization for pytest";
    license = licenses.bsd0;
    maintainers = [ maintainers.costrouc ];
    # see https://github.com/bitprophet/pytest-relaxed/issues/12
    broken = true;
  };
}
