{ stdenv, buildPythonPackage, fetchPypi, pytest, mock }:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "pytest-rerunfailures";
  version = "4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "18lpy6d9b4ck8j3jwh4vmxj54is0fwanpmpg70qg4y0fycdqzwks";
  };

  buildInputs = [ pytest mock ];

  checkPhase = ''
    py.test
  '';

  meta = with stdenv.lib; {
    description = "pytest plugin to re-run tests to eliminate flaky failures.";
    homepage = https://github.com/pytest-dev/pytest-rerunfailures;
    license = licenses.mpl20;
    maintainers = with maintainers; [ jgeerds ];
    platforms = platforms.all;
  };
}
