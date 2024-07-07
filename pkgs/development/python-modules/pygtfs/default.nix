{
  lib,
  buildPythonPackage,
  docopt,
  fetchPypi,
  nose,
  pytz,
  pythonOlder,
  setuptools-scm,
  six,
  sqlalchemy,
}:

buildPythonPackage rec {
  pname = "pygtfs";
  version = "0.1.9";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-J5vu51OOMabWd8h60PpvvBiCnwQlhEnBywNXxy9hOuA=";
  };

  postPatch = ''
    # https://github.com/jarondl/pygtfs/pull/72
    substituteInPlace setup.py \
      --replace "pytz>=2012d" "pytz"
  '';

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [
    docopt
    pytz
    six
    sqlalchemy
  ];

  nativeCheckInputs = [ nose ];

  pythonImportsCheck = [ "pygtfs" ];

  meta = with lib; {
    description = "Python module for GTFS";
    mainProgram = "gtfs2db";
    homepage = "https://github.com/jarondl/pygtfs";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
