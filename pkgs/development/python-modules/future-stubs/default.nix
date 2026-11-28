{ lib, buildPythonPackage, fetchPypi, future }:

buildPythonPackage rec {
  pname = "future-stubs";
  version = "0.18.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ae42148268d32d25643bd0f985d528924d17c2830b49a13a5b289e22878ca000";
  };

  propagatedBuildInputs = [ future ];

  # As packaged in pypi, the future-stubs library had several minor but fatal
  # packaging problems. These patches fix the problems:
  # - setup.cfg references a LICENSE.txt file that doesn't exist.
  # - setup.py install_requires "python-future" instead of "future"
  # - The package is missing the `py.typed` files that mypy requires.
  patches = [ ./001-fix-setup-files.patch ./002-add-py.typed-files.patch ];

  meta = with lib; {
    description = "PEP 561 stubs for python-future";
    homepage = "https://python-future.org";
    license = licenses.mit;
    maintainers = with maintainers; [ mkohler ];
  };
}
