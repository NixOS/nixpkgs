{ lib
, buildPythonPackage
, fetchPypi
, requests
, pytest
, mock
, sphinx
}:

buildPythonPackage rec {
  pname = "readthedocs-sphinx-ext";
  version = "0.5.16";

  src = fetchPypi {
    inherit pname version;
    sha256 = "42b1c63d63dd483a188b541599bd08a540b2d08ec2b166660179618b6ccc3bb0";
  };

  propagatedBuildInputs = [ requests ];

  checkInputs = [ pytest mock sphinx ];

  checkPhase = ''
    py.test
  '';

  # https://github.com/rtfd/readthedocs-sphinx-ext/pull/60
  doCheck = false;

  meta = with lib; {
    description = "Sphinx extension for Read the Docs overrides";
    homepage = http://github.com/rtfd/readthedocs-sphinx-ext;
    # Not sure which one: https://github.com/rtfd/readthedocs-sphinx-ext/issues/59
    license = licenses.bsdOriginal;
  };
}
