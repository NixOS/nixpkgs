{ lib
, buildPythonPackage
, fetchPypi
, pytest
, readme_renderer
}:

buildPythonPackage rec {
  pname = "readme";
  version = "0.7.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "32fbe1538a437da160fa4e4477270bfdcd8876e2e364d0d12898302644496231";
  };

  checkInputs = [
    pytest
  ];

  propagatedBuildInputs = [
    readme_renderer
  ];

  checkPhase = ''
    pytest
  '';

  # tests are not included with pypi release
  # package is not readme_renderer
  doCheck = false;

  meta = with lib; {
    description = "Readme is a library for rendering readme descriptions for Warehouse";
    homepage = "https://github.com/pypa/readme";
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };

}
