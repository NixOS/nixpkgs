{ lib
, buildPythonPackage
, fetchPypi
, makefun
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "decopatch";
  version = "1.4.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0i6i811s2j1z0cl6y177dwsbfxib8dvb5c2jpgklvc2xy4ahhsy6";
  };

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [ makefun ];

  postPatch = ''
    substituteInPlace setup.py --replace "'pytest-runner', " ""
  '';

  # Tests would introduce multiple cirucular dependencies
  # Affected: makefun, pytest-cases
  doCheck = false;

  pythonImportsCheck = [ "decopatch" ];

  meta = with lib; {
    description = "Python helper for decorators";
    homepage = "https://github.com/smarie/python-decopatch";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
