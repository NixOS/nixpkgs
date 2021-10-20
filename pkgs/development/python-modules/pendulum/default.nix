{ lib, fetchPypi, buildPythonPackage, pythonOlder
, python-dateutil
, importlib-metadata
, poetry
, poetry-core
, pytzdata
, typing
}:

buildPythonPackage rec {
  pname = "pendulum";
  version = "2.1.2";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b06a0ca1bfe41c990bbf0c029f0b6501a7f2ec4e38bfec730712015e8860f207";
  };

  preBuild = ''
    export HOME=$TMPDIR
  '';

  nativeBuildInputs = [ poetry-core ];
  propagatedBuildInputs = [ python-dateutil pytzdata ]
  ++ lib.optional (pythonOlder "3.5") typing
  ++ lib.optionals (pythonOlder "3.8") [ importlib-metadata ];

  # No tests
  doCheck = false;

  meta = with lib; {
    description = "Python datetimes made easy";
    homepage = "https://github.com/sdispater/pendulum";
    license = licenses.mit;
  };
}
