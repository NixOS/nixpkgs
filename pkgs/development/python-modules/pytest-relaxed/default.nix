{ stdenv
, buildPythonPackage
, fetchPypi
, pytest
, six
, decorator
}:

buildPythonPackage rec {
  version = "1.1.4";
  pname = "pytest-relaxed";

  src = fetchPypi {
    inherit pname version;
    sha256 = "511ac473252baa67d5451f7864516e2e8f1acedf0cef71f79d2ed916ee04e146";
  };

  propagatedBuildInputs = [ pytest six decorator ];

  patchPhase = ''
    sed -i "s/pytest>=3,<3.3/pytest/g" setup.py
  '';

  # skip tests due to dir requirements
  doCheck = false;

  checkPhase = ''
    pytest tests
  '';

  meta = with stdenv.lib; {
    homepage = https://pytest-relaxed.readthedocs.io/;
    description = "Relaxed test discovery/organization for pytest";
    license = licenses.bsd0;
    maintainers = [ maintainers.costrouc ];
  };
}
