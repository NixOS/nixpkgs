{ stdenv
, fetchPypi
, buildPythonPackage
, setuptools_scm
, cython
}:

buildPythonPackage rec {
  pname = "pyclipper";
  version = "1.2.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "0irs5sn6ldpg70630nfndghjnpxv8jldk61zyczfzp1jcz53b43s";
  };

  nativeBuildInputs = [
    setuptools_scm
    cython
  ];

  # Requires pytest_runner to perform tests, which requires deprecated
  # features of setuptools. Seems better to not run tests. This should
  # be fixed upstream.
  doCheck = false;
  pythonImportsCheck = [ "pyclipper" ];

  meta = with stdenv.lib; {
    description = "Cython wrapper for clipper library";
    homepage    = "https://github.com/fonttools/pyclipper";
    license     = licenses.mit;
    maintainers = with maintainers; [ matthuszagh ];
  };
}
